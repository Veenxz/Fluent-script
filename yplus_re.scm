;RP Variable Create Function
(define (make-new-rpvar name default type)
 (if (not (rp-var-object name))
     (rp-var-define name default type #f)))

;RP Variable Declarations
(make-new-rpvar 'myudf/velocity 1.0 'real) ;freestream velocity
(make-new-rpvar 'myudf/density 1.0 'real);density
(make-new-rpvar 'myudf/mu 1.0 'real) ;mu
(make-new-rpvar 'myudf/length 1.0 'real) ; Length
(make-new-rpvar 'myudf/yplus 1.0 'real) ; yplus
(make-new-rpvar 'myudf/deltas 0.0 'real) ;/deltaS    
(make-new-rpvar 'myudf/re 0.0 'real) ;Re

;Dialog Box Definition
(define gui-dialog-box
 ;Let Statement, Local Variable Declarations
 (let ((dialog-box #f)
   (table)
       (myudf/box1)
       (myudf/box2)
       (myudf/velocity)
       (myudf/density)
       (myudf/mu)
       (myudf/length)
       (myudf/yplus)
       (myudf/deltas)
       (myudf/re)
      )
      
      ;Update-CB Function, Invoked When Dialog Box Is Opened
      (define (update-cb . args)
           (cx-set-real-entry myudf/velocity 1.0)
           (cx-set-real-entry myudf/density 1.225)
           (cx-set-real-entry myudf/mu 1.78938e-05)
           (cx-set-real-entry myudf/length 1.0)
           (cx-set-real-entry myudf/yplus 1.0)
           (cx-set-real-entry myudf/deltas 0.0)
           (cx-set-real-entry myudf/re 0.0)
      )
      
      ;Apply-CB Function, Invoked When "OK" Button Is Clicked
      (define (apply-cb . args)
         (Cal)
      )  

     ;定义函数计算雷诺数与第一层网格高度
     (define (Cal)
       (rpsetvar 'myudf/velocity (cx-show-real-entry myudf/velocity))
       (rpsetvar 'myudf/density (cx-show-real-entry myudf/density))
       (rpsetvar 'myudf/mu (cx-show-real-entry myudf/mu))
       (rpsetvar 'myudf/length (cx-show-real-entry myudf/length))
       (rpsetvar 'myudf/yplus (cx-show-real-entry myudf/yplus))
       (rpsetvar 'myudf/deltas (cx-show-real-entry myudf/deltas))
       (rpsetvar 'myudf/re (cx-show-real-entry myudf/re))

       (define re (rpgetvar 'myudf/re))
       (define density (rpgetvar 'myudf/density))
       (define mu (rpgetvar 'myudf/mu))
       (define length (rpgetvar 'myudf/length))
       (define yplus (rpgetvar 'myudf/yplus))
       (define deltas (rpgetvar 'myudf/deltas))
       (define velocity (rpgetvar 'myudf/velocity))
       (define cf)
       (define tau)
       (define u_fric)

       (set! re (* density (* velocity (/ length mu))))
       (set! cf (/ 0.026 (expt re (/ 1 7))))
       (set! tau (* cf (* density (* velocity (/ velocity 2)))))
       (set! u_fric (sqrt (/ tau density)))
       (set! deltas (* yplus (/ mu (* u_fric density))))

       (cx-set-real-entry myudf/deltas deltas)
       (cx-set-real-entry myudf/re re)
     )
      
      ;Button-CB Function, Invoked When "Test Button" Is Clicked
      (define (button-cb . args)
         (cal)
      )       
      ;Args Function, Used For Interface Setup, Required For Apply-CB, Update-CB, and Button-CB Sections
            
      (lambda args
        (if (not dialog-box)
          (let ()
            (set! dialog-box (cx-create-panel "Turbulent Calculator" apply-cb update-cb))
            (set! table (cx-create-table dialog-box "" 'border #f 'below 0 'right-of 0))  
                          
            (set! myudf/box1 (cx-create-table table "Data Inputs" 'row 0))
            (set! myudf/velocity (cx-create-real-entry myudf/box1 "Velocity[m/s]:" 'row 0))
            (set! myudf/density (cx-create-real-entry myudf/box1 "Density[kg/m3]:" 'row 1))
            (set! myudf/mu (cx-create-real-entry myudf/box1 "Viscosity[Pa.s]:" 'row 2))
            (set! myudf/length (cx-create-real-entry myudf/box1 "Length[m]:" 'row 3))
            (set! myudf/yplus (cx-create-real-entry myudf/box1 "YPlus:" 'row 4))
            (cx-create-button table "Calculate" 'activate-callback button-cb 'row 1)
            (set! myudf/box2 (cx-create-table table "Data Output" 'row 2))
            (set! myudf/deltas (cx-create-real-entry myudf/box2 "DeltaS[m]" 'row 0))
            (set! myudf/re (cx-create-real-entry myudf/box2 "Re:" 'row 1))  
          ) ;End Of Let Statement
        ) ;End Of If Statement         
        ;Call To Open Dialog Box
        (cx-show-panel dialog-box)
      ) ;End Of Args Function
 ) ;End Of Let Statement
) ;End Of GUI-Dialog-Box Definition

(gui-dialog-box)