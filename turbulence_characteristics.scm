(define apply-cb #t)
(define update-cb #f)

(define velocity 1.0)
(define density 1.225)
(define mu 1.78938e-05)
(define L 1.0)

(define tk 0.0)
(define ti 0.0)
(define tl 0.0)
(define te 0.0)
(define muratio 0.0)
(define omega 0.0)

(define (update-cb . args)
 (cx-set-real-entry density 1.225)
 (cx-set-real-entry velocity 1.0)
 (cx-set-real-entry mu 1.78938e-05)
 (cx-set-real-entry L 1.0)
)

(define (Calc)
 (define Rvelocity (cx-show-real-entry velocity))
 (define Rdensity (cx-show-real-entry density))
 (define Rmu (cx-show-real-entry mu))
 (define RL (cx-show-real-entry L))
 (define Rtk 0.0)
 (define Rti 0.0)
 (define Rtl 0.0)
 (define Rte 0.0)
 (define Rmuratio 0.0)
 (define Romega 0.0)
 (define Re 0.0)
 (define Rmut 0.0)
 (define cu 0.09)
;开始计算
 (set! Rtl (/ (* 0.07 RL) (expt cu 0.75)))  ;计算特征尺度
 (set! Re (* Rdensity (* RL (/ Rvelocity Rmu)))) ;计算雷诺数
 (set! Rti (* 0.16 (expt Re (/ -1 8)))) ;计算湍流强度
 (set! Rtk (* 1.5 (expt (* Rvelocity Rti) 2))) ;计算湍动能
 (set! Rte (/  (expt Rtk 1.5) Rtl)) ;计算湍流耗散率
 (set! Rmut (/ (* Rdensity 0.09 (* Rtk Rtk)) Rte)) ;计算湍流粘度
 (set! Rmuratio (/ Rmut Rmu)) ;计算湍流粘度比
 (set! Romega (/ (expt Rtk 0.5) (* cu Rtl))) ;计算比耗散率
  
  (cx-set-real-entry tk Rtk)
  (cx-set-real-entry ti Rti)
  (cx-set-real-entry tl Rtl)
  (cx-set-real-entry te Rte)
  (cx-set-real-entry muratio Rmuratio)
  (cx-set-real-entry omega Romega)

  
 (display (string-append "Reynold Number :" (number->string Re)))
 (newline)
 (display (string-append "Length scale :" (number->string Rtl) " m"))
 (newline)
 (display (string-append "turbulent kinetic:" (number->string Rtk) " m2/s3"))
 (newline)
 (display (string-append "turbulent intensity :" (number->string Rti) " m2/s2"))
 (newline)
 (display (string-append "turbulent Dissipation Rate :" (number->string Rte) " m2/s3"))
 (newline)
 (display (string-append "turbulent viscosity :" (number->string Rmu) " kg/(m.s)"))
 (newline)
 (display (string-append "turbulent viscosity ratio :" (number->string Rmuratio) ))
 (newline)
 (display (string-append "omega :" (number->string Romega) " 1/s"))  
)

(define (apply-cb . args)
 (Calc)
)

(define (button-cb . args)
 (Calc)
)

(define dialog-box (cx-create-panel "Turbulent Para" apply-cb update-cb))
(define table (cx-create-table dialog-box "" 'border #f 'below 0 'right-of 0))            
(define box1 (cx-create-table table "Data Inputs" 'row 0 'col 0))
(define myDropList (cx-create-drop-down-list box1 "Compute From:" 'row 0 'col 0))
(cx-set-list-items myDropList (map thread-name (sort-threads-by-name(get-face-threads))))

(set! velocity (cx-create-real-entry box1 "Velocity[m/s]:" 'row 1 'col 0))
(set! density (cx-create-real-entry box1 "Density[kg/m3]:" 'row 2))
(set! mu (cx-create-real-entry box1 "Viscosity[Pa.s]:" 'row 3))
(set! L (cx-create-real-entry box1 "Length[m]:" 'row 4))
(cx-create-button table "Calculate>>" 'activate-callback button-cb 'row 1  )
(define box2 (cx-create-table table "Data Output" 'row 0 'col 2))
(set! tk (cx-create-real-entry box2 "Turbulent Kinetic Energy[m3/s2]:" 'row 1))  
(set! ti (cx-create-real-entry box2 "Turbulent Intensity[m2/s2]:" 'row 2))   
(set! tl (cx-create-real-entry box2 "Turbulent Scale[m]:" 'row 3))    
(set! te (cx-create-real-entry box2 "Turbulent Dissipation Rate[m2/s3]:" 'row 4))   
(set! muratio (cx-create-real-entry box2 "Turbulent Viscosity Ratio:" 'row 5)) 
(set! omega (cx-create-real-entry box2 "omega[1/s]:" 'row 6))

(cx-show-panel dialog-box)