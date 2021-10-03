---FUNCTION vasitesile
CREATE OR REPLACE FUNCTION f (n NUMBER) RETURN NUMBER IS -- Funksiya yaradib daxil edeceyimiz fibonacci reqemini in/out n le adlandirdim
BEGIN
IF 
  (n = 1) or (n = 2) THEN RETURN 1; -- Daxil edeceyim fibonacci reqemi 2 oldugu halda mene 1 cavabi qaytarmagni istedim
ELSIF
  (n = 0) THEN RETURN 0; -- Daxil edeceyim fibonacci reqemi 0 oldugu halda mene 0 cavabi qaytarmagni istedim
ELSE
  RETURN f(n - 1) + f(n - 2); -- Qalan hallarda fibonacci dusturundan(F(n)=F(n-1)+F(n-2)) isdifade etmesini istedim. 
END IF;
END;
------------------------------------------------------------------------------------------------------------

---ANONIM BLOK vasitesile
declare
v_bir number := 0; --v_bir deyisenine 0 menimsedirem.
v_iki number := 1; --v_iki deyisenine 1 menimsedirem sayin 1den baslamasi ucun.
v_novbeti number; --v_novbeti deyisenine onde v_bir ve v_iki deyisenlerin cemini menimsedecem.
v_fib_n number :=&n; -- v_fib_n deyisenine fibonacci reqemini menimsedirem.
begin
   dbms_output.put_line(v_bir);
   dbms_output.put_line(v_iki);
    for i in 2..v_fib_n --for loop vasitesile 2den teyin etdiyim deyisene qeder dovre baslamasini deyirem.
    loop
        v_novbeti:=v_bir+v_iki;
        v_bir := v_iki;
        v_iki := v_novbeti;
   dbms_output.put_line(v_novbeti);  --dbms burda yazsam butun gedisati gosterecek.
end loop;
--      dbms_output.put_line(v_novbeti);
end;
-------------------------------------------------------------------------------------------------------------


