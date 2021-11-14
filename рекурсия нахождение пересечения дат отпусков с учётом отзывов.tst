PL/SQL Developer Test script 3.0
137
-- Created on 12.11.2021 by USER 
declare
  type T is record(
    rn   number(6),
    dbeg date,
    dend date);
  C     T;
  RTABC T;
  type tABC is table of T;
  tAa  tABC := tabc();
  tBb  tABC := tabc();
  tCc  tABC := tabc();
  ct   number(6) := 0;
  ct1  number(6);
  tbeg date;
  msg  varchar2(300) := 'There are no intersections.';
  b    boolean := false;

  function rcur return boolean is
    prn  number(6) := tbb(ct).rn;
    pbeg date := tbb(ct).dbeg;
    pend date := tbb(ct).dend;
  begin
    for recb in (select t.* from pdata t where t.storno = 1 order by t.dbeg) loop
      case
      --периоды не пересекаются
        when (recb.dbeg < pbeg and recb.dend < pend and recb.dend < pbeg) or
             (recb.dbeg > pbeg and recb.dend > pend and recb.dbeg > pend) then
          null;
          --период поглощён отзывом
        when recb.dbeg <= pbeg and recb.dend >= pend then
          tbb.delete(ct);
          ct := ct - 1;
          return true;
          --правый остаток
        when recb.dbeg <= pbeg and recb.dend < pend  and recb.dend >= pbeg then
          tbb(ct).rn := prn;
          tbb(ct).dbeg := recb.dend + 1;
          tbb(ct).dend := pend;
          --левый остаток
        when recb.dbeg > pbeg and recb.dend >= pend and recb.dbeg <= pend then
          tbb(ct).rn := prn;
          tbb(ct).dbeg := pbeg;
          tbb(ct).dend := recb.dbeg - 1;
          --разделение на два остатка
        else
          dbms_output.put_line('Double --> source: ' || prn || '  ' || pbeg ||
                               ' - ' || pend || chr(13) ||
                               '           storno: ' || recb.rn || '  ' ||
                               recb.dbeg || ' - ' || recb.dend || chr(13) ||
                               '        left_period: ' || prn || '  ' || pbeg ||
                               ' - ' || (recb.dbeg - 1) || chr(13) ||
                               '       right_period: ' || prn || '  ' ||
                               (recb.dend + 1) || ' - ' || pend);
          --левая часть
          tbb(ct).rn := prn;
          tbb(ct).dbeg := pbeg;
          tbb(ct).dend := recb.dbeg - 1;
          b := rcur();
          --правая часть
          tbb.extend;
          ct := ct + 1;
          tbb(ct).rn := prn;
          tbb(ct).dbeg := recb.dend + 1;
          tbb(ct).dend := pend;
          b := rcur();
      end case;
    end loop;
    return true;
  end;
begin
  c.rn   := 3;
  c.dbeg := to_date('02.07.2021');
  c.dend := c.dbeg + 28;
  --создать вложенную таблицу с результатом вычитания отзывов
  for reca in (select t.* from pdata t where t.storno = 0 order by t.dbeg) loop
    tbb.extend;
    ct := ct + 1;
    tbb(ct).rn := reca.rn;
    tbb(ct).dbeg := reca.dbeg;
    tbb(ct).dend := reca.dend;
    b := rcur();
  end loop;
  for ct in 1 .. tbb.count loop
    dbms_output.put_line(ct || ' : ' || tbb(ct).rn || '  ' || tbb(ct).dbeg ||
                         ' - ' || tbb(ct).dend);
  end loop;
end;
/*  ct := 1;
  --раскрыть таблицу периодов отзывов
  for rec in (select t.* from pdata t where t.storno = 1 order by t.dbeg) loop
    tbeg := rec.dbeg;
    loop
      exit when tbeg = rec.dend + 1;
      RTABC.rn   := rec.rn;
      RTABC.dbeg := tbeg;
      tbb.extend;
      tbb(ct) := RTABC;
      --dbms_output.put_line(ct||' : '||tbb(ct).rn||' - '||tbb(ct).dbeg);
      tbeg := tbeg + 1;
      ct   := ct + 1;
    end loop;
  end loop;
  ct := 1;
  --раскрыть таблицу тестируемого периода
  tbeg := c.dbeg;
  loop
    exit when tbeg = c.dend + 1;
    RTABC.rn   := c.rn;
    RTABC.dbeg := tbeg;
    tcc.extend;
    tcc(ct) := RTABC;
    --dbms_output.put_line(ct || ' : ' || tcc(ct).rn || ' - ' || tcc(ct).dbeg);
    tbeg := tbeg + 1;
    ct   := ct + 1;
  end loop;
  --выполнить левый внешний джойн для курсорных втаблиц
  for ct in 1 .. taa.count loop
    for ct1 in 1 .. tbb.count loop
      if taa(ct).dbeg = tbb(ct1).dbeg then
        taa(ct).dbeg := null;
      end if;
    end loop;
  end loop;
  --найти пересечения для втаблицы джойна с втаблицей теста
  --при наличии пересечения вывести данные о пересекаемой записи в втаблице джойна
  for ct in 1 .. taa.count loop
    for ct1 in 1 .. tcc.count loop
      if taa(ct).dbeg = tcc(ct1).dbeg then
        msg := 'Found a intersection!' || chr(13) || tcc(ct1).rn || ' new period: ' || tcc(ct1).dbeg ||
               ' - ' || tcc(ct1).dend || chr(13) || taa(ct).rn || ' old period: ' || taa(ct).dbeg ||
               ' - ' || taa(ct).dend;
        exit;
      end if;
    end loop;
  end loop;
  dbms_output.put_line(msg);*/
0
0
