/* 
ELABORAZIONE FEATURE
- Calcolo gli indicatori per ogni singolo cliente (riferiti a id_cliente).
*/

-- Indicatori di base: 
-- 1. Età del cliente

drop temporary table if exists banca.feature_eta_cliente;
create temporary table banca.feature_eta_cliente as
	select 
    id_cliente, 
    data_nascita, -- per verifica
    timestampdiff(year, data_nascita, current_timestamp()) as eta
    from banca.cliente;
    
select * from banca.feature_eta_cliente;

-- Indicatori sulle transazioni:
-- 2. Numero transazioni in uscita su tutti i conti
-- 3. Numero transazioni in entrata su tutti i conti
-- 4. Importo totale in uscita su tutti i conti
-- 5. Importo totale in entrata su tutti i conti
-- Nota: arrotondo gli importi a 2 decimali per maggiore leggibilità

drop temporary table if exists banca.feature_transazioni_cliente;
create temporary table banca.feature_transazioni_cliente as
	select cl.id_cliente,
	count(case when tipo_trz.segno = '-' then 1 else null end) as num_transazioni_uscita,
    count(case when tipo_trz.segno = '+' then 1 else null end) as num_transazioni_entrata,
	round(sum(case when tipo_trz.segno = '-' then trz.importo else 0 end), 2) as importo_tot_uscita,
	round(sum(case when tipo_trz.segno = '+' then trz.importo else 0 end), 2) as importo_tot_entrata
	from banca.transazioni trz
	join banca.tipo_transazione tipo_trz on trz.id_tipo_trans = tipo_trz.id_tipo_transazione
    join banca.conto cnt on trz.id_conto =  cnt.id_conto
    join banca.cliente cl on cnt.id_cliente = cl.id_cliente 
    group by 1;
    
select * from banca.feature_transazioni_cliente;

-- Indicatori sui conti:
-- 6. Numero totale di conti
-- 7. Numero di conti per tipologia (un indicatore per ogni tipo di conto)

drop temporary table if exists banca.feature_conti_cliente;
create temporary table banca.feature_conti_cliente
	select cl.id_cliente,
	count(distinct cnt.id_conto) as num_tot_conti,
	count(distinct case when tipo_cnt.desc_tipo_conto =  'Conto Base' then cnt.id_conto else null end) as num_conto_base,
	count(distinct case when tipo_cnt.desc_tipo_conto =  'Conto Business' then cnt.id_conto else null end) as num_conto_business,
	count(distinct case when tipo_cnt.desc_tipo_conto =  'Conto Privati' then cnt.id_conto else null end) as num_conto_privati,
	count(distinct case when tipo_cnt.desc_tipo_conto =  'Conto Famiglie' then cnt.id_conto else null end) as num_conto_famiglie
	from banca.conto cnt 
	join banca.tipo_conto tipo_cnt on cnt.id_tipo_conto = tipo_cnt.id_tipo_conto
	join banca.cliente cl on cnt.id_cliente = cl.id_cliente 
	group by 1;

select * from banca.feature_conti_cliente;

-- Indicatori sulle transazioni per tipologia di conto
-- 8. Numero transazioni in uscita per tipologia di conto (un indicatore per tipo di conto)
-- 9. Numero transazioni in entrata per tipologia di conto (un indicatore per tipo di conto)
-- 10. Importo in uscita per tipologia di conto (un indicatore per tipo di conto)
-- 11. Importo in entrata per tipologia di conto (un indicatore per tipo di conto)
-- Nota: arrotondo gli importi a 2 decimali per maggiore leggibilità

drop temporary table if exists banca.feature_transazioni_cliente_by_tipo_conto;
create temporary table banca.feature_transazioni_cliente_by_tipo_conto
	select cl.id_cliente,
		count(case when tipo_trz.segno = '-' and tipo_cnt.desc_tipo_conto = 'Conto Base' then 1 else null end) as num_transazioni_uscita_conto_base,
        count(case when tipo_trz.segno = '+' and tipo_cnt.desc_tipo_conto = 'Conto Base' then 1 else null end) as num_transazioni_entrata_conto_base,
        round(sum(case when tipo_trz.segno = '-' and tipo_cnt.desc_tipo_conto = 'Conto Base' then trz.importo else 0 end), 2) as importo_tot_uscita_conto_base,
        round(sum(case when tipo_trz.segno = '+' and tipo_cnt.desc_tipo_conto = 'Conto Base' then trz.importo else 0 end), 2) as importo_tot_entrata_conto_base,

        count(case when tipo_trz.segno = '-' and tipo_cnt.desc_tipo_conto = 'Conto Business' then 1 else null end) as num_transazioni_uscita_conto_business,
        count(case when tipo_trz.segno = '+' and tipo_cnt.desc_tipo_conto = 'Conto Business' then 1 else null end) as num_transazioni_entrata_conto_business,
        round(sum(case when tipo_trz.segno = '-' and tipo_cnt.desc_tipo_conto = 'Conto Business' then trz.importo else 0 end), 2) as importo_tot_uscita_conto_business,
        round(sum(case when tipo_trz.segno = '+' and tipo_cnt.desc_tipo_conto = 'Conto Business' then trz.importo else 0 end), 2) as importo_tot_entrata_conto_business,

        count(case when tipo_trz.segno = '-' and tipo_cnt.desc_tipo_conto = 'Conto Privati' then 1 else null end) as num_transazioni_uscita_conto_privati,
        count(case when tipo_trz.segno = '+' and tipo_cnt.desc_tipo_conto = 'Conto Privati' then 1 else null end) as num_transazioni_entrata_conto_privati,
        round(sum(case when tipo_trz.segno = '-' and tipo_cnt.desc_tipo_conto = 'Conto Privati' then trz.importo else 0 end), 2) as importo_tot_uscita_conto_privati,
        round(sum(case when tipo_trz.segno = '+' and tipo_cnt.desc_tipo_conto = 'Conto Privati' then trz.importo else 0 end), 2) as importo_tot_entrata_conto_privati,

        count(case when tipo_trz.segno = '-' and tipo_cnt.desc_tipo_conto = 'Conto Famiglie' then 1 else null end) as num_transazioni_uscita_conto_famiglie,
        count(case when tipo_trz.segno = '+' and tipo_cnt.desc_tipo_conto = 'Conto Famiglie' then 1 else null end) as num_transazioni_entrata_conto_famiglie,
        round(sum(case when tipo_trz.segno = '-' and tipo_cnt.desc_tipo_conto = 'Conto Famiglie' then trz.importo else 0 end), 2) as importo_tot_uscita_conto_famiglie,
        round(sum(case when tipo_trz.segno = '+' and tipo_cnt.desc_tipo_conto = 'Conto Famiglie' then trz.importo else 0 end), 2) as importo_tot_entrata_conto_famiglie
		from banca.transazioni trz
		join banca.tipo_transazione tipo_trz on trz.id_tipo_trans = tipo_trz.id_tipo_transazione
		join banca.conto cnt on trz.id_conto =  cnt.id_conto
		join banca.tipo_conto tipo_cnt on cnt.id_tipo_conto = tipo_cnt.id_tipo_conto
		join banca.cliente cl on cnt.id_cliente = cl.id_cliente 
		group by 1;

select  * from banca.feature_transazioni_cliente_by_tipo_conto;


/* 
CREAZIONE FEATURE TABLE
- La tabella finale sarà una tabella denormalizzata con informazioni qualitative e quantitative (feature) riferite all'id_cliente. 
*/
-- NOTA: uso COALESCE per pulizia e coerenza nei risultati -> mostro 0 invece del NULL in caso di mancato valore

drop table if exists banca.feature_cliente;
create table banca.feature_cliente as
    select
    cl.id_cliente,
    f_eta.eta,

    coalesce(f_trz.num_transazioni_uscita, 0) as num_transazioni_uscita,
    coalesce(f_trz.num_transazioni_entrata, 0) as num_transazioni_entrata,
    coalesce(f_trz.importo_tot_uscita, 0) as importo_tot_uscita,
    coalesce(f_trz.importo_tot_entrata, 0) as importo_tot_entrata,

    coalesce(f_cnt.num_tot_conti, 0) as num_tot_conti,
    coalesce(f_cnt.num_conto_base, 0) as num_conto_base,
    coalesce(f_cnt.num_conto_business, 0) as num_conto_business,
    coalesce(f_cnt.num_conto_privati, 0) as num_conto_privati,
    coalesce(f_cnt.num_conto_famiglie, 0) as num_conto_famiglie,

    coalesce(f_trz_tipo_cnt.num_transazioni_uscita_conto_base, 0) as num_transazioni_uscita_conto_base,
    coalesce(f_trz_tipo_cnt.num_transazioni_entrata_conto_base, 0) as num_transazioni_entrata_conto_base,
    coalesce(f_trz_tipo_cnt.importo_tot_uscita_conto_base, 0) as importo_tot_uscita_conto_base,
    coalesce(f_trz_tipo_cnt.importo_tot_entrata_conto_base, 0) as importo_tot_entrata_conto_base,

    coalesce(f_trz_tipo_cnt.num_transazioni_uscita_conto_business, 0) as num_transazioni_uscita_conto_business,
    coalesce(f_trz_tipo_cnt.num_transazioni_entrata_conto_business, 0) as num_transazioni_entrata_conto_business,
    coalesce(f_trz_tipo_cnt.importo_tot_uscita_conto_business, 0) as importo_tot_uscita_conto_business,
    coalesce(f_trz_tipo_cnt.importo_tot_entrata_conto_business, 0) as importo_tot_entrata_conto_business,

    coalesce(f_trz_tipo_cnt.num_transazioni_uscita_conto_privati, 0) as num_transazioni_uscita_conto_privati,
    coalesce(f_trz_tipo_cnt.num_transazioni_entrata_conto_privati, 0) as num_transazioni_entrata_conto_privati,
    coalesce(f_trz_tipo_cnt.importo_tot_uscita_conto_privati, 0) as importo_tot_uscita_conto_privati,
    coalesce(f_trz_tipo_cnt.importo_tot_entrata_conto_privati, 0) as importo_tot_entrata_conto_privati,

    coalesce(f_trz_tipo_cnt.num_transazioni_uscita_conto_famiglie, 0) as num_transazioni_uscita_conto_famiglie,
    coalesce(f_trz_tipo_cnt.num_transazioni_entrata_conto_famiglie, 0) as num_transazioni_entrata_conto_famiglie,
    coalesce(f_trz_tipo_cnt.importo_tot_uscita_conto_famiglie, 0) as importo_tot_uscita_conto_famiglie,
    coalesce(f_trz_tipo_cnt.importo_tot_entrata_conto_famiglie, 0) as importo_tot_entrata_conto_famiglie
    from banca.cliente cl 
    left join banca.feature_eta_cliente f_eta on cl.id_cliente = f_eta.id_cliente
    left join banca.feature_transazioni_cliente f_trz on cl.id_cliente = f_trz.id_cliente
    left join banca.feature_conti_cliente f_cnt on cl.id_cliente = f_cnt.id_cliente
    left join banca.feature_transazioni_cliente_by_tipo_conto f_trz_tipo_cnt on cl.id_cliente = f_trz_tipo_cnt.id_cliente;
    
select * from  banca.feature_cliente;