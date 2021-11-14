--select 'Русский', to_date('02.jun.2021') from dual;
select t.* from pdata t order by t.storno,  t.dbeg;
