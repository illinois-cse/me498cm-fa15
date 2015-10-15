;;
;; Do complete simulation run
;;

(define prefix "siphon-test04d")
(define title "siphon test04d")

(define timestep 0.01)                 ;; time step for iterations
(define iterations (/ 60 timestep))    ;; how many iterations to do (20 seconds real time)
(define frame_every (/ 0.02 timestep)) ;; how many time steps per frame (0.05  =20 fps)
(define iter_per_timestep 50)          ;; iterations per time step

(define outputmovie (format #f "~a.avi" prefix))
(define meshfile "model/siphon04d.msh")

(define inlet-wait 3)					; seconds to wait before run
(define inlet-amplitude -0.1e5) ; 0.1 Pa below std
(define inlet-period 2.0)

(define title (format #f "~a; timestep ~a; iters/step ~a" title timestep iter_per_timestep))
(define title (format #f "~a; inlet [amplitude ~a; period ~a]" title inlet-amplitude inlet-period))

;; Must be called after loading, but before phase definition!
(define (init-customfield)
	(and
		;; XXX next must be _first_ defined custom function *sigh*
		(ti-menu-load-string "define/custom-field-functions/define \"energy-density-potential\" density*9.81*y_coordinate")
		(ti-menu-load-string "define/custom-field-functions/define \"energy-density-kinetic\" 0.5*density*velocity_magnitude^2")
	)
)

; UDF for periodic inlet
(rp-var-define 'periodic-halfsine-profile/amplitude 2 'real #f)	; Pa
(rp-var-define 'periodic-halfsine-profile/period 2 'real #f)    ; s
(rp-var-define 'periodic-halfsine-profile/wait 2 'real #f)      ; s
(rpsetvar 'periodic-halfsine-profile/amplitude inlet-amplitude)
(rpsetvar 'periodic-halfsine-profile/period inlet-period)
(rpsetvar 'periodic-halfsine-profile/wait inlet-wait)
(ti-menu-load-string "define/user-defined/interpreted-functions \"udf/periodic-halfsine-profile.c\" ,,n")


(define (patch-phase)
	  (and
			; Make sure we have some water
			(ti-menu-load-string "/adapt/mark-inout-rectangle y n -20.0  3.0   0.0 5.7")
			(ti-menu-load-string "/adapt/mark-inout-rectangle y n  2.0 20.0   0.0 4.8")
			(ti-menu-load-string "/solve/patch phase-2 () (0 1) mp n 1")

			; half a cos wave
			;(ti-menu-load-string "/define/custom-field-functions/define \"sine-wave-box\" .2*cos(PI*x_coordinate)+0.5-y_coordinate")
			;(ti-menu-load-string "/adapt/mark-inout-iso-range y mixture sine-wave-box 0 1")
			;(ti-menu-load-string "/solve/patch phase-2 () (0) mp n 1")

			;; When different regions are defined
			;;(ti-menu-load-string "/solve/patch phase-2 (air) mp 1")
			;;(ti-menu-load-string "/solve/patch phase-2 (water) mp 0")
		)
)

;(cx-graphics-layout 0 0.137539 0.994571 -0.466699 0.998146) ; dual-monitor
(cx-graphics-layout 0 -0.976484 0.995392 -0.785058 0.888771) ; single-monitor

(load "initial-setup.scm")
(load "create-movie.scm")

;; getmedata reporting
(ti-menu-load-string "/surface/point-surface getmedata-point-01 0.2 0.5")

;; Custom solver settings
(ti-menu-load-string "/define/models/noniterative-time-advance n")
	; y = solve vof for every iteration
(ti-menu-load-string "/define/models/multiphase vof 2 geo-reconstruct 0.25 n,,")
;; View for this setup
(ti-menu-load-string "/view/default-view")
(ti-menu-load-string "/view/camera/zoom-camera 1.5")
(ti-menu-load-string "/solve/monitors/residual/plot y")

; Autosave
(system "mkdir -p autosave")
(system "rm -f autosave/*")
(ti-menu-load-string "/file/autosave/root-name \"autosave/case\"")
(ti-menu-load-string "/file/autosave/case-frequency 50")
(ti-menu-load-string "/file/autosave/data-frequency 50")

(define (do-simulation)
	(and
		;; start transcript here to avoid clutter of function loading
		(ti-menu-load-string "/file/start-transcript fluent.log y")

		;; Optionally change last stuff
		;; XXX should do before initialization and patching?
		(ti-menu-load-string (format #f "/display/set/title \"~a\"" title))


		;; Do simulations
		(ti-menu-load-string (format #f "/solve/dual-time-iterate ~d ~d" iterations iter_per_timestep))

		;; Gather results
		(movie-finish)

		;; Bye!
		(ti-menu-load-string "/file/stop-transcript")
		(exit)
	)
)

; Final boundary conditions settings
;(ti-menu-load-string "/define/boundary-conditions/modify-zone/zone-type lefttop pressure-inlet")
;(ti-menu-load-string "/define/boundary-conditions/modify-zone/zone-type leftmiddle velocity-inlet")
;(ti-menu-load-string "/define/boundary-conditions/modify-zone/zone-type leftdown velocity-inlet")
;(ti-menu-load-string "/define/boundary-conditions/velocity-inlet leftmiddle mixture n n y y n 0.2")
;(ti-menu-load-string "/define/boundary-conditions/velocity-inlet leftmiddle phase-2 n 1")
;(ti-menu-load-string "/define/boundary-conditions/velocity-inlet leftdown mixture n n y y n 0.2")
;(ti-menu-load-string "/define/boundary-conditions/velocity-inlet leftdown phase-2 n 1")
(ti-menu-load-string "/define/boundary-conditions/modify-zone/zone-type inlet pressure-inlet")
(ti-menu-load-string "/define/boundary-conditions/pressure-inlet inlet mixture y y \"udf\" \"periodic_halfsine_profile\" n , n y")
(ti-menu-load-string "/define/boundary-conditions/velocity-inlet leftmiddle phase-2 n 0")

(do-simulation)

;; vim:ts=2:sw=2:ft=scheme:
