#   Hell Gate Bridge

This exercise will introduce the use of multiple element types in a single model.

The Hell Gate Bridge<sup>[[Wikipedia](https://en.wikipedia.org/wiki/Hell_Gate_Bridge)][[NYCRoads](http://www.nycroads.com/crossings/hell-gate/)]</sup> is a $1\,017 \,\text{ft}$ steel through arch railway bridge in New York City built in 1916 to link two major railroads.  We will model the steel portions of the bridge for stress analysis, although there are also concrete towers on both ends which would be interesting to include.

![](./img/hell-gate-bridge.png)

We will use English units. just so you have some experience working with these in ANSYS.  The units type is:  pound-force/inch/second.  Thus we expect Young's modulus $E$ to be expressed in—well, in what?  We'll have to derive it via Newton's second law, $F = m/a \rightarrow m = F/a = \frac{[\text{lbf}]}{[\text{in}][\text{s}^{2}]} = \frac{[\text{lbf}]\cdot[\text{s}]^{2}}{[\text{in}]}$.  Finally you can be introduced to the "pound-force second squared per inch"<sup>[[Scholl2007](http://www.padtinc.com/blog/wp-content/uploads/oldblog/PADT_TheFocus_61.pdf)]</sup>, commonly known as the [*slinch*](https://www.unc.edu/~rowlett/units/dictS.html#slinch) (and originally defined by NASA!).  (Incidentally, [here](http://www.dynasupport.com/howtos/general/consistent-units) is a table of consistent units across unit systems.)

-   Set the title to "`Hell Gate Bridge`" and the jobname to `bridge`.

-   Type `\PREP7` to invoke the preprocessor.  Input the keypoints from `hell-gate-bridge-keypoints.txt`.
    
    ![](./img/keypoints.txt)

-   Reproduce the lines in the below graphic as the left-hand symmetric image of the Hell Gate Bridge.
    
    ![](./img/lines.txt)

-   Set the element type to `beam188`.  (We will revisit this after making sure the model works properly.)
    
        et 1,188
        nlgeom, on

-   The beam section should be the conventional square, `■`, with width and depth of `1.0`.

-   The bridge is made of an unspecified steel; we will use A36 steel<sup>[[Wikipedia](https://en.wikipedia.org/wiki/A36_steel)]</sup>, `linear`, `elastic`, `isotropic`, $E = 2.9\times 10^{7} \,\text{psi}$, $\nu = 0.26$.

-   Set the manual size `NDIV` of the mesh elements to `1`.  Mesh all lines.
    
    ![](./img/mesh.png)

-   Set the loads as below.

`FY` to `-1000` (slinches, thus $1.7513 \times 10^{5} \,\text{kg}$) at some point

-   Solve the system.

-   Examine the (minimal) displacement of the solved system.

-   Create an element table to examine the stress:  `etable,stress,ls,1` and then plot these results.

The changes are small but sensible.

The next step is to change up the element types in use.  We will retain `beam188` elements for the upper structure, but switch to `link180` for the cables (which have minimal bending resistance, although no off-axis forces will be applied) and a different `beam188` for the road frame.

-   First, clear the previous mesh and save the model.

-   We need to add each element individually.

    -   Retain element 1, `beam188`.
    
    -   Add `link180` as element 2.
    
    -   Add `beam188` (again) as element 3.

-   Define the material parameters associated with each of these.

    -   The main truss will consist of 

(check ASCE paper, 1918)

## References

-   <a id="Ammann1918">Ammann1918</a>:  The Hell Gate Arch Bridge and approaches of the New York Connecting Railroad over the East River in New York City.  *Trans. ASCE*, paper 1417.









(Also, compare other bridge designs as HW?)