create or replace procedure p_VacIsecDays(prn  in number,
                                          pbeg in date,
                                          pend in date) is
  type T is record(
    rn   number(6),
    dbeg date,
    dend date);
  type tABC is table of T;
  tAa tABC := tabc();
  tBb tABC := tabc();
  tCc tABC := tabc();
  ct  number(4) := 0;
  ct1 number(2);
  b   boolean := true;
begin
  --заполнить втаблицы днями периодов
  --раскрыть таблицу периодов отпусков
  for rec in (select t.* from pdata t where t.storno = 0 order by t.dbeg) loop
    for ct1 in 1 .. (rec.dend - rec.dbeg + 1) loop
      taa.extend;
      taa(ct + ct1).rn := rec.rn;
      taa(ct + ct1).dbeg := rec.dbeg + ct1 - 1;
      taa(ct + ct1).dend := rec.dend;
    end loop;
    ct := ct + rec.dend - rec.dbeg + 1;
  end loop;
  --раскрыть таблицу периодов отзывов
  ct := 0;
  for rec in (select t.* from pdata t where t.storno = 1 order by t.dbeg) loop
    for ct1 in 1 .. (rec.dend - rec.dbeg + 1) loop
      tbb.extend;
      tbb(ct + ct1).rn := rec.rn;
      tbb(ct + ct1).dbeg := rec.dbeg + ct1 - 1;
      tbb(ct + ct1).dend := rec.dend;
          dbms_output.put_line(tbb(ct+ct1).dbeg||' - '||tbb(ct+ct1).dend);
    end loop;
    ct := ct + rec.dend - rec.dbeg + 1;
  end loop;
  --раскрыть таблицу тестируемого периода
  for ct in 1 .. (pend - pbeg + 1) loop
    tcc.extend;
    tcc(ct).rn := prn;
    tcc(ct).dbeg := pbeg + ct - 1;
    tcc(ct).dend := pend; 
  end loop;
  --выполнить left outer join отпусков с отзывами
  for ct in 1 .. taa.count loop
    for ct1 in 1 .. tbb.count loop
      if taa(ct).dbeg = tbb(ct1).dbeg then
        taa(ct).dbeg := null;
      end if;
    end loop;
  end loop;
  --проверить пересечение введённого отпуска
  for ct in 1 .. taa.count loop
    for ct1 in 1 .. tcc.count loop
      if taa(ct).dbeg = tcc(ct1).dbeg and b then
        dbms_output.put_line('InterSectPeriod: ' || taa(ct).rn || '  ' || taa(ct).dbeg ||
                             ' - ' || taa(ct).dend);
        b := false;
      end if;
    end loop;
  end loop;
end;
/
