PL/SQL Developer Test script 3.0
24
declare
  nrn    number(6) := 99999;
  dbeg   date ;
  dend   date ;
  nday   number(2);
  nmonth number(2);
  i number(2);
begin
  for i in 0 .. 30 loop
  loop
    nday   := dbms_random.value(1, 31);
    nmonth := dbms_random.value(1, 12);
    dbeg := to_date(nday||'.'||nmonth||'.2021');
    exit when not ((nmonth = 2 and nday > 28) or (nmonth in (4,6,9,11) and nday = 31));
  end loop;
  dend := dbeg + 28;
  dbms_output.put_line(chr(13)||'Start conditions: ' || nrn || '  ' || dbeg ||
                       ' - ' || dend);
  dbms_output.put_line('p_VacIsecDays:');
  p_vacisecdays(prn => nrn, pbeg => dbeg, pend => dend);
  dbms_output.put_line('p_VacIsec:');
  p_vacisec(prn => nrn, pbeg => dbeg, pend => dend);
  end loop;
end;
0
1
ct
