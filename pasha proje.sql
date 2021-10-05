--------------------1---------------------
--başlama ve bitme tarixini qəbul edən 2 formal parametirli funksiya yaradıram
create or replace function f_count_saturday (fi_start_date date,fi_end_date date) return number is
--v_count dəyişəni Saturday-lərin sayını görsədəcək
v_count number:=0;
--başlanğıc və bitmə tarixəri dəyişənlərinə formal parametrləri mənimsədirəm
v_start_date date:=fi_start_date;
v_end_date date:=fi_end_date;
begin
  loop
  --əgər tarix Saturday dirsə v_counta 1 əlavə etsin
    if trim(to_char(v_start_date,'Day'))='Saturday' then v_count:=v_count+1;
    end if;
  --hər dövrdə başlanğıc tarixin üstünə 1 gün əlavə etsin
    v_start_date:=v_start_date+1;
  --başlanğıc tarixi bitmə tarixindən çox olduqda loopdan çıxsın
    exit when v_start_date>v_end_date;
  end loop;
--Funksiya Saturdaylərin sayını qaytarsın
  return v_count;
end;
--------------------------------------------------------

------------------2-----------------------
-- 1 formal parametirli funksiya yaradıram varchar2 tipində
create or replace function f_palindrom (fi_pal varchar2) return varchar2 is
--nəticəni görsədəcək dəyişən yazıram
 v_result varchar2(100);
--parametre daxil edilən sözün tərsini mənimsədiləcək dəyişən yazıram
 v_reverse varchar2(1000);
begin
  --1dən daxil edilən paramtrin uzunluğuna qədər davam edəcək dövr yazıram
  for n in reverse 1 .. length (fi_pal)
  loop
    --v_reverse dəyişəninə hər dövrdə daxil edilən parametrin dövrün sayından başlayaraq 1-ci simvolu mənimsədirəm
     v_reverse := v_reverse || substr (fi_pal, n, 1);
  end loop;
  --əgər daxil edilən parametrlə v_reverse(sözün tərsi) eynidirsə nəticəyə Yes,deyilsə No mənimsədsin deyirəm
  if fi_pal=v_reverse then v_result:='Yes it is palendrom';
  else v_result:='No it isn''t palindrom';
  end if;
  --funksiya v_result(nəticəni) qaytarsın
 return v_result;
end;
-------------------------------------------------------

-----------------3---------------------------
-- 1 formal parametirli funksiya yaradıram number tipində
create or replace function f_sum (fi_number number) return number is
--daxil edilən rəqəmlərin cəmini mənimsədəcəyim dəyişən yazıram və öncədən 0 mənimsədirəm ki null olmasın null olduqda toplama getmiyəcək
v_sum number:=0;
begin
  --əgər daxil edilən rəqəm mənfi olarsa dövrə 2-ci simvoldan başlamağını deyirəm
  if fi_number like '-%' then
    for j in 2..length(fi_number) 
      loop
      --yazdığım cəm dəyişəninə dəyişənin özünü və dövrün sıra sayına uyğun ilk rəqəmi toplayıb mənimsədirəm(to_number əgər rəqəm arasında nöqtə olarsa onu 0 hesablasın)
       v_sum:=v_sum+to_number(substr(fi_number,j,1),'99,999.999');
      end loop;
  else 
   --əks halda dövrə 1 ci simvoldan başlasın və eyni emeliiyatı etsin
    for i in 1..length(fi_number) 
      loop
       v_sum:=v_sum+to_number(substr(fi_number,i,1),'99,999.999');
      end loop;
  end if;
 --funksiya cəm dəyişənini qaytarsın          
 return v_sum;
end;
--------------------------------------------------------

----------------4---------------------------
--parametrsiz procedur yaradıram
create or replace procedure p_sync is
--cursor yaradıb 1ci cədvəldə olub 2 ci cədvəldə olmayanları çıxarmaq üçün minusdan istifadə edirəm
cursor c_emp is
select * from employees_test
minus
select * from employees_test1;
--cursor yaradıb 2ci cədvəldə olub 1 ci cədvəldə olmayanları çıxarmaq üçün minusdan istifadə edirəm
cursor c_emp1 is
select * from employees_test1
minus
select * from employees_test;

begin
  --c_emp cursoruna əsasən dövrə başlasın
  for i in c_emp 
   loop
    --cursorun verdiyi nəticələri 2ci cədvələ insert etsin
    insert into employees_test1 
    values (i.employee_id,i.first_name,i.last_name,i.email,i.phone_number,i.hire_date,i.job_id,i.salary,i.commission_pct,i.manager_id,i.department_id) ;
   end loop;
  --c_emp2 cursoruna əsasən dövrə başlasın
  for j in c_emp1 
   loop
    --cursorun verdiyi nəticələri 1ci cədvələ insert etsin
    insert into employees_test 
    values (j.employee_id,j.first_name,j.last_name,j.email,j.phone_number,j.hire_date,j.job_id,j.salary,j.commission_pct,j.manager_id,j.department_id) ;
   end loop;
end;
----------------------------------------------

---------------------5--------------------------
--sadə vurma cədvəli anonim blokda
begin
  --başlıq olaraq 1 dəfə çıxarsın yazını
  dbms_output.put_line('--MULTIPICATION TABLE--'); 
  --1dən 9a qədər dövrə başlasın
  for i in 1..9 
   loop
     dbms_output.put_line('---------------');
     dbms_output.put_line(i);--dövrdə hazırkı rəqəmi çıxarsın
     dbms_output.put_line('---------------');   
    --nested loop,yenidən 1dən 9a qədər dövrə başlasın
    for j in 1..9 
     loop
      --1ci dövrün rəqəmlərini 2-ci dovrün hər bir rəqəminə vurub nəticəni çıxarsın
      dbms_output.put_line(i||'x'||j||'='||(i*j));  
     end loop;
   end loop;
end;
--------------------5.2--------------------------
--collection vasitəsilə anonim blokda sağa doğru ekrana çıxarılan vurma cədvəli
declare
--9 sütün qəbul edən number formatında varray type yaradıram
type t_multi is varray(9) of number;
--dəyişən yazıram həmin typeda
v_mult t_multi:=t_multi(1,2,3,4,5,6,7,8,9);
begin
--1 dəfə təkrarlanan dövrə başlasın
for i in 1..1 loop
  --1dən 9a qədər dövr eləsin və hər dövrdə öz dövründəki rəqəmləri 1 ci dövrün rəqəminə vurub nəticəni çıxarsın
  for j in 1..9 loop
  dbms_output.put_line(v_mult(1)||'X'||J||'='||rpad((v_mult(1)*j),5)||
                       v_mult(2)||'X'||J||'='||rpad((v_mult(2)*j),5)||
                       v_mult(3)||'X'||J||'='||rpad((v_mult(3)*j),5)||
                       v_mult(4)||'X'||J||'='||rpad((v_mult(4)*j),5)||
                       v_mult(5)||'X'||J||'='||rpad((v_mult(5)*j),5)||
                       v_mult(6)||'X'||J||'='||rpad((v_mult(6)*j),5)||
                       v_mult(7)||'X'||J||'='||rpad((v_mult(7)*j),5)||
                       v_mult(8)||'X'||J||'='||rpad((v_mult(8)*j),5)||
                       v_mult(9)||'X'||J||'='||v_mult(9)*j);
  end loop; 
end loop;
end; 
--------------------------------------------------

-------------------6------------------------------


--hemin vaxda başqa yerdə delete eemeliyati gede biler o sebebden 5min gozleyib
--həmin cədvəl üzrə begin transaction yazıb işə başlana bilər və commit ve ya rollback transaction verilənəcən nəticəni qaytarmaz



--------------------------------------------------

-------------------7------------------------------
--daxil edilən məlumatın uzunluğundan həmin məlumatda ! ların yerini heçnə ilə dəyişdirilmişinin uzunluğunu çıxırıq və nəticəni alırıq
select length('!salam!l!!!!!')-length(replace('!salam!l!!!!!','!','')) from dual;
------------------7.2-----------------------------
--regexp_count funksiyasına ! nı daxil edib melumatın içindəki nidaların sayını tapırıq
select regexp_count('!salam!l!!!!!','!') from dual
--------------------------------------------------

------------------8------------------------------







--------------------------------------------------

------------------9-------------------------------
--oktyabr adında bir sütünlu table yaradıram
create table october (october_days date);

declare
--dəyişənlərə başlama və bitmə tarini mənimsədirəm
v_date date:='01-oct-2021';
v_date2 date:='31-oct-2021';
begin
  -- sadə dövrə başlayıram
 loop
 --october cədvəlinə başlama tarixi olan dəyişəni insert edirəm
 insert into october values(v_date);
 --hər dövrdə başlama tarixinin üstünə 1 gün elavə edirəm
 v_date:=v_date+1;
 --başlama tarixi bitmə tarixindən çox olduqda dövrdən çıxsın
 exit when v_date>v_date2;
 end loop;
 --insert bitirdikdən sonra yadda saxlasın
 commit;
end;

/*october cədvəlindən case when ilə select edirəm,həmin tarixin günləri əgər Monday,Tuesday....Sunday olduğu halda onları ASCİİ vasitəsilə tapdığım hərflərlə 
əvəz etsin Bazar ertəsi,Çərşənbə axşamı ..... Bazar*/
select october_days,
    case trim(to_char(october_days,'Day'))
     when 'Monday' then 'BAZAR ERT'||chr(50831)||'S'||chr(50352)
     when 'Tuesday' then chr(50055)||chr(50831)||'R'||chr(50590)||chr(50831)||'NB'||chr(50831)||' '||'AX'||chr(50590)||'AMI'
     when 'Wednesday' then chr(50055)||chr(50831)||'R'||chr(50590)||chr(50831)||'NB'||chr(50831)
     when 'Thursday' then 'C'||chr(50076)||'M'||chr(50831)||' '||'AX'||chr(50590)||'AMI'
     when 'Friday' then 'C'||chr(50076)||'M'||chr(50831)
     when 'Saturday' then chr(50590)||chr(50831)||'NB'||chr(50831)
     when 'Sunday' then 'BAZAR'
     end from october;
---------------------9.2------------------------------------
--Yuxarıdakı prosesi cədvəl yaradmadan anonim blok vasitəsilə 2 dəyişən yazıb(başlama və bitmə tarixi) if elsif vasitəsilə etmək mümkündür
declare
v_date date:='01-oct-2021';
v_date2 date:='31-oct-2021';
begin
 loop
   if trim(to_char(v_date,'Day'))='Monday' then dbms_output.put_line(v_date||' BAZAR ERTƏSİ');
   elsif trim(to_char(v_date,'Day'))='Tuesday' then dbms_output.put_line(v_date||' ÇƏRŞƏNBƏ AXŞAMI');
   elsif trim(to_char(v_date,'Day'))='Wednesday' then dbms_output.put_line(v_date||' ÇƏRŞƏNBƏ');
   elsif trim(to_char(v_date,'Day'))='Thursday' then dbms_output.put_line(v_date||' CÜMƏ AXŞAMI');
   elsif trim(to_char(v_date,'Day'))='Friday' then dbms_output.put_line(v_date||' CÜMƏ');
   elsif trim(to_char(v_date,'Day'))='Saturday' then dbms_output.put_line(v_date||' ŞƏNBƏ');
   elsif trim(to_char(v_date,'Day'))='Sunday' then dbms_output.put_line(v_date||' BAZAR');
   end if;
    v_date:=v_date+1;
 exit when v_date>v_date2;
 end loop;
end;
---------------------------------------------------
