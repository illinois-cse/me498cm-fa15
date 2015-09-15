/batch,list
/title, Illustrate use of 5D table for SF command (pressure) loading
!!!!
!!!!
                                !!!! create 5D table for applied pressure
X1=2                            !!!! X dimensionality
Y1=2                            !!!! Y dimensionality
Z1=10                           !!!! Z dimensionality
D4=5                            !!!! time dimensionality
D5=5                            !!!! temperature dimensionality
len=10                          !!!! cantilever beam length
wid=1                           !!!! cantilever beam width
hth=2                           !!!! cantilever beam height

*dim,xval,array,X1              !!!! create 1D arrays to load 5D table
xval(1)=0,20                    !!!! variations per dimension same
*dim,yval,array,Y1              !!!! but give different values on each
yval(1)=0,20                    !!!! book and shelf
*dim,zval,array,10
zval(1)=10,20,30,40,50,60,70,80,90,100
*dim,tval,array,5
tval(1)=1,.90,.80,.70,.60
*dim,tevl,array,5
tevl(1)=1,1.20,1.30,1.60,1.80
*dim,ccc,tab5,X1,Y1,Z1,D4,D5,X,Y,Z,TIME,TEMP
*taxis,ccc(1,1,1,1,1),1,0,wid   !!! X-Dim
*taxis,ccc(1,1,1,1,1),2,0,hth   !!! Y-Dim
*taxis,ccc(1,1,1,1,1),3,1,2,3,4,5,6,7,8,9,10 !!! Z-Dim
*taxis,ccc(1,1,1,1,1),4,0,10,20,30,40  !!! Time
*taxis,ccc(1,1,1,1,1),5,0,50,100,150,200 !!! Temp
*do,ii,1,2
  *do,jj,1,2
    *do,kk,1,10
      *do,ll,1,5
        *do,mm,1,5
          ccc(ii,jj,kk,ll,mm)=(xval(ii)+yval(jj)+zval(kk))*tval(ll)*tevl(mm)
        *enddo
      *enddo
    *enddo
  *enddo
*enddo

/prep7
block,,wid,,hth,,len            !!!! create beam volume
et,1,5                          !!!! use SOLID5

esize,0.5                       !!!! element size
mshkey,1                        !!!! mapped mesh
vmesh,all

mp,ex,1,1e7                     !!!! material properties
mp,nuxy,1,.3
mp,kxx,1,1

nsel,s,loc,z,0                  !!!! fix end of beam
d,all,all
fini
save                            !!!! save problem for future restart
/solu
antyp,trans
timint,off

asel,u,loc,z,0
sfa,all,1,pres,%ccc%            !!!! apply pressure to all selected areas
alls
time,1e-3                       !!!! first solution at time = "0"
nsub,1
outres,all,all                  !!!! output everything to results file
d,all,temp,0                    !!!! for first problem, temp = 0
solve

time,30                         !!!! second solution, time=30
d,all,temp,150                  !!!! second solution, temp=150
solve
finish
/post1
/view,1,1,1,1
/psf,press,norm,3,0,1
/pbc,all,0
set,1,1
/title, Pressure distribution; time=0, temp=0
eplot
set,2,1
/title, Pressure distribution; time=30, temp=150
eplot
finish