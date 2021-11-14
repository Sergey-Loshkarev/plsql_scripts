create or replace procedure p_VacIsec(prn  in number,
                                      pbeg in date,
                                      pend in date) is
  type T is record(
    rn   number(6),
    dbeg date,
    dend date);
  type tABC is table of T;
  tBb tABC := tabc();
  ct  number(6) := 0;
  b   boolean := false;
  function rcur return boolean is
    prn  number(6);
    pbeg date;
    pend date;
  begin
    for recb in (select t.* from pdata t where t.storno = 1 order by t.dbeg) loop
      prn  := tbb(ct).rn;
      pbeg := tbb(ct).dbeg;
      pend := tbb(ct).dend;
      case
      --периоды не пересекаются
        when (recb.dbeg < pbeg and recb.dend < pend and recb.dend < pbeg) or
             (recb.dbeg > pbeg and recb.dend > pend and recb.dbeg > pend) then
          null;
          --период поглощён отзывом
        when recb.dbeg <= pbeg and recb.dend >= pend then
          tbb.trim;
          ct := ct - 1;
          return true;
          --правый остаток
        when recb.dbeg <= pbeg and recb.dend < pend and recb.dend >= pbeg then
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
  --создать вложенную таблицу с результатом вычитания отзывов
  for reca in (select t.* from pdata t where t.storno = 0 order by t.dbeg) loop
    tbb.extend;
    ct := ct + 1;
    tbb(ct).rn := reca.rn;
    tbb(ct).dbeg := reca.dbeg;
    tbb(ct).dend := reca.dend;
    b := rcur();
  end loop;
  --проверить пересечение введённого отпуска
  for ct in 1 .. tbb.count loop
    if not (pend < tbb(ct).dbeg or pbeg > tbb(ct).dend) then
      dbms_output.put_line('InterSectPeriod: ' || tbb(ct).rn || '  ' || tbb(ct).dbeg ||
                           ' - ' || tbb(ct).dend);
      exit;
    end if;
  end loop;
end p_VacIsec;
/
