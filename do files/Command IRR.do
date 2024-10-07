program define irr, rclass
version 10
syntax varname [if] [in]
marksample touse
quietly count if `touse'
if `r(N)' == 0 error 2000
mata: irr("`varlist'", "`touse'")
disp as txt "Internal Rate of Return = " as res scalar(irr)
disp as txt `v4'
return scalar NPV = scalar(NPV)
return scalar irr = scalar(irr)
end

mata:
void irr(string scalar vname,
string scalar touse)
{
        st_view(v1=., ., vname, touse)

// validate Net Current Value
        v4 = v1'*J(rows(v1), 1, 1)
        v5 = v1[1]
        v3 = J(1,1,.)
        v2 = J(rows(v1), 1, 0)
        irr0 = .0001
        v3bis = J(1,1,.)
        v2bis = J(rows(v1), 1, 0)
        irr_bis = 1
         
			 
			 for (i=1;i<=rows(v1);i++) {
                        j = i - 1
                        di = 1/(1+irr_bis)^j
                        v2bis[i] = di
                }
                v3bis = v1'*v2bis
                if (v3bis[1]>0) {
                        irr0 = irr_bis

                }
        
        for (i=1;i<=rows(v1);i++) {
                j = i - 1
                di = 1/(1+irr0)^j
                v2[i] = di
        }
        v3 = v1'*v2
        if (v3[1]>=0) {
                irr = irr0
        }
        irrplus = irr/10
        while (v3[1]>=.00001) {
                for (i=1;i<=rows(v1);i++) {
                        j = i - 1
                        di = 1/(1+irr)^j
                        v2[i] = di
                }
        v3 = v1'*v2
        st_numscalar("irr", irr)
        st_numscalar("NPV", v3)
        irr = irr + irrplus
        }
}
end
