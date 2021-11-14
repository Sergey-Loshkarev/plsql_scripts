PL/SQL Developer Test script 3.0
33
-- Created on 06.11.2021 by USER 
declare
  -- Local variables here
  i        number(1) := 0;
  irn      news.rn%type;
  vrn      news.rn%type;
  vcaption news.caption%type;
  vtext    news.text%type;
  vdate    news.ndate%type;
begin
  -- Test statements here
  for i in 0 .. 9 loop
    loop
      vrn := dbms_random.value(1, 999999);
      begin
        select rn into irn from news where rn = vrn;
      exception
        when no_data_found then
          dbms_output.put_line(vrn);
          exit;
      end;
    end loop;
    vcaption := dbms_random.string('u', 40);
    dbms_output.put_line(vcaption);
    vtext := dbms_random.string('l', 80);
    vtext := vtext || sys.utl_tcp.CRLF || dbms_random.string('l', 80);
    dbms_output.put_line(vtext);
    vdate := sysdate + 1 + i;
    dbms_output.put_line(vdate);
    insert into news (rn, caption, text, ndate) values (vrn, vcaption, vtext, vdate);
    --commit;
  end loop;
end;
0
0
