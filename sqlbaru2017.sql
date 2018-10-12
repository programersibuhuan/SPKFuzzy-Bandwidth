-- ----------------------------
-- View structure for `query-rules`
-- ----------------------------
DROP VIEW IF EXISTS `query-rules`;
CREATE VIEW `query-rules` AS select `a`.`rule_id` AS `ruleid`,`a`.`rulename` AS `rulename`,`a`.`trafik_jaringan_b` AS `bw`,`a`.`j_pelanggan_cmt` AS `jml`,`a`.`kualitas_ck` AS `serv`,`a`.`fuzzy_output` AS `fz` from `rules` `a`;

-- ----------------------------
-- View structure for `query-rule-pelanggan`
-- ----------------------------
DROP VIEW IF EXISTS `query-rule-pelanggan`;
CREATE VIEW `query-rule-pelanggan` AS select `a`.`net_id` AS `netid`,`a`.`jml_pelanggan` AS `jml`,if((((`a`.`jml_pelanggan` >= 0) and (`a`.`jml_pelanggan` < 66.6)) or (`a`.`jml_pelanggan` = 33.3)),1,0) AS `sedikit`,if((((`a`.`jml_pelanggan` >= 33.3) and (`a`.`jml_pelanggan` < 100)) or (`a`.`jml_pelanggan` = 66.6)),1,0) AS `sedang`,if((((`a`.`jml_pelanggan` >= 66.6) and (`a`.`jml_pelanggan` < 100)) or (`a`.`jml_pelanggan` = 100)),1,0) AS `banyak` from `network` `a`;

-- ----------------------------
-- View structure for `query-rule-bandwidth`
-- ----------------------------
DROP VIEW IF EXISTS `query-rule-bandwidth`;
CREATE VIEW `query-rule-bandwidth` AS select `a`.`net_id` AS `netid`,`a`.`bandwidth` AS `b`,if((((`a`.`bandwidth` >= 0) and (`a`.`bandwidth` < 66.6)) or (`a`.`bandwidth` = 33.3)),1,0) AS `sedikit`,if((((`a`.`bandwidth` >= 33.3) and (`a`.`bandwidth` < 100)) or (`a`.`bandwidth` = 66.6)),1,0) AS `sedang`,if((((`a`.`bandwidth` >= 66.6) and (`a`.`bandwidth` < 100)) or (`a`.`bandwidth` = 100)),1,0) AS `banyak` from `network` `a`;

-- ----------------------------
-- View structure for `query-rule-pelayanan`
-- ----------------------------
DROP VIEW IF EXISTS `query-rule-pelayanan`;
CREATE VIEW `query-rule-pelayanan` AS select `a`.`net_id` AS `netid`,`a`.`pelayanan` AS `serv`,if((((`a`.`pelayanan` >= 0) and (`a`.`pelayanan` < 66.6)) or (`a`.`pelayanan` = 33.3)),1,0) AS `buruk`,if((((`a`.`pelayanan` > 33.3) and (`a`.`pelayanan` < 100)) or (`a`.`pelayanan` = 66.6)),1,0) AS `cukup`,if((((`a`.`pelayanan` >= 66.6) and (`a`.`pelayanan` < 100)) or (`a`.`pelayanan` = 100)),1,0) AS `baik` from `network` `a`;

-- ----------------------------
-- View structure for `view-query-fuzzy-value`
-- ----------------------------
DROP VIEW IF EXISTS `view-query-fuzzy-value`;
CREATE VIEW `view-query-fuzzy-value` AS select `a`.`netid` AS `netid`,`a`.`b` AS `b`,`b`.`jml` AS `cmt`,`c`.`serv` AS `cks`,if((`a`.`sedikit` = 1),round((`a`.`b` / 33.3),2),0) AS `bwmin`,if((`a`.`sedang` = 1),round(((100 - `a`.`b`) / 33.3),2),0) AS `bwmid`,if((`a`.`banyak` = 1),round(((`a`.`b` - 66.6) / 33.3),2),0) AS `bwmax`,if((`b`.`sedikit` = 1),round((`b`.`jml` / 33.3),2),0) AS `jmlmin`,if((`b`.`sedang` = 1),round(((100 - `b`.`jml`) / 33.3),2),0) AS `jmlmid`,if((`b`.`banyak` = 1),round(((`b`.`jml` - 66.6) / 33.3),2),0) AS `jmlmax`,if((`c`.`buruk` = 1),round((`c`.`serv` / 33.3),2),0) AS `servmin`,if((`c`.`cukup` = 1),round(((100 - `c`.`serv`) / 33.3),2),0) AS `servmid`,if((`c`.`baik` = 1),round(((`c`.`serv` - 66.6) / 33.3),2),0) AS `servmax` from ((`query-rule-bandwidth` `a` join `query-rule-pelanggan` `b` on((`b`.`netid` = `a`.`netid`))) join `query-rule-pelayanan` `c` on((`c`.`netid` = `a`.`netid`)));
-- ----------------------------
-- View structure for `query-himpunan`
-- ----------------------------
DROP VIEW IF EXISTS `query-himpunan`;
CREATE VIEW `query-himpunan` AS select `a`.`netid` AS `netid`,`a`.`b` AS `b`,`b`.`jml` AS `jml`,`c`.`serv` AS `serv`,`a`.`sedikit` AS `bwmin`,`a`.`sedang` AS `bwmid`,`a`.`banyak` AS `bwmax`,`b`.`sedikit` AS `jmlmin`,`b`.`sedang` AS `jmlmid`,`b`.`banyak` AS `jmlmax`,`c`.`buruk` AS `servmin`,`c`.`cukup` AS `servmid`,`c`.`baik` AS `servmax` from ((`query-rule-bandwidth` `a` join `query-rule-pelanggan` `b` on((`a`.`netid` = `b`.`netid`))) join `query-rule-pelayanan` `c` on((`c`.`netid` = `a`.`netid`)));


-- ----------------------------
-- View structure for `view-query-rulebase`
-- ----------------------------
DROP VIEW IF EXISTS `view-query-rulebase`;
CREATE VIEW `view-query-rulebase` AS select `a`.`netid` AS `netid`,`a`.`b` AS `b`,`a`.`jml` AS `j`,`a`.`serv` AS `s`,`b`.`ruleid` AS `ruleid`,`b`.`rulename` AS `rulename`,`b`.`bw` AS `bw`,`b`.`jml` AS `jml`,`b`.`serv` AS `serv`,`b`.`fz` AS `fz` from (`query-himpunan` `a` join `query-rules` `b`) where (((`b`.`bw` = convert(if((`a`.`bwmin` = 1),'Sedikit','') using latin1)) or (`b`.`bw` = convert(if((`a`.`bwmid` = 1),'Sedang','') using latin1)) or (`b`.`bw` = convert(if((`a`.`bwmax` = 1),'Banyak','') using latin1))) and ((`b`.`jml` = convert(if((`a`.`jmlmin` = 1),'Sedikit','') using latin1)) or (`b`.`jml` = convert(if((`a`.`jmlmid` = 1),'Sedang','') using latin1)) or (`b`.`jml` = convert(if((`a`.`jmlmax` = 1),'Banyak','') using latin1))) and ((`b`.`serv` = convert(if((`a`.`servmin` = 1),'Buruk','') using latin1)) or (`b`.`serv` = convert(if((`a`.`servmid` = 1),'Cukup','') using latin1)) or (`b`.`serv` = convert(if((`a`.`servmax` = 1),'Baik','') using latin1)))) order by `a`.`netid`,`b`.`ruleid`;

-- ----------------------------
-- View structure for `view-query-predikat`
-- ----------------------------
DROP VIEW IF EXISTS `view-query-predikat`;
CREATE VIEW `view-query-predikat` AS select `a`.`netid` AS `id`,`b`.`ruleid` AS `ruleid`,`b`.`rulename` AS `rulename`,`b`.`b` AS `bw`,`b`.`j` AS `jml`,`b`.`s` AS `serv`,if((`b`.`bw` = 'Sedikit'),`a`.`bwmin`,if((`b`.`bw` = 'Sedang'),`a`.`bwmid`,`a`.`bwmax`)) AS `alpha_bw`,if((`b`.`jml` = 'Sedikit'),`a`.`jmlmin`,if((`b`.`jml` = 'Sedang'),`a`.`jmlmid`,if((`b`.`jml` = 'Banyak'),`a`.`jmlmax`,''))) AS `alpha_jml`,if((`b`.`serv` = 'Buruk'),`a`.`servmin`,if((`b`.`serv` = 'Cukup'),`a`.`servmid`,`a`.`servmax`)) AS `alpha_serv`,`b`.`fz` AS `fz` from (`view-query-fuzzy-value` `a` left join `view-query-rulebase` `b` on((`a`.`netid` = `b`.`netid`)));

-- ----------------------------
-- View structure for `query-weighted`
-- ----------------------------
DROP VIEW IF EXISTS `query-weighted`;
CREATE VIEW `query-weighted` AS select `a`.`id` AS `id`,`a`.`ruleid` AS `ruleid`,`a`.`rulename` AS `rulename`,`a`.`bw` AS `bw`,`a`.`jml` AS `jml`,`a`.`serv` AS `serv`,`a`.`fz` AS `fz`,least(`a`.`alpha_bw`,`a`.`alpha_jml`,`a`.`alpha_serv`) AS `min`,if((`a`.`fz` = 'Normal'),10,100) AS `WA` from `view-query-predikat` `a`;


-- ----------------------------
-- View structure for `query-sum-weighted`
-- ----------------------------
DROP VIEW IF EXISTS `query-sum-weighted`;
CREATE VIEW `query-sum-weighted` AS select `query-weighted`.`id` AS `id`,`query-weighted`.`ruleid` AS `ruleid`,`query-weighted`.`rulename` AS `rulename`,`query-weighted`.`bw` AS `bw`,`query-weighted`.`jml` AS `jml`,`query-weighted`.`serv` AS `serv`,`query-weighted`.`fz` AS `fz`,`query-weighted`.`min` AS `min`,`query-weighted`.`WA` AS `WA`,sum(`query-weighted`.`min`) AS `fo_atas`,sum((`query-weighted`.`WA` * `query-weighted`.`min`)) AS `fo_bawah` from `query-weighted` group by `query-weighted`.`id`;


-- ----------------------------
-- View structure for `query-fuzzy-final`
-- ----------------------------
DROP VIEW IF EXISTS `query-fuzzy-final`;
CREATE VIEW `query-fuzzy-final` AS select `a`.`id` AS `id`,`a`.`bw` AS `bw`,`a`.`jml` AS `jml`,`a`.`serv` AS `serv`,`a`.`fz` AS `fz`,`a`.`min` AS `min`,`a`.`WA` AS `WA`,(`a`.`fo_bawah` / `a`.`fo_atas`) AS `fuzzy` from `query-sum-weighted` `a`;
-- ----------------------------
-- View structure for `query-fuzzy-output`
-- ----------------------------
DROP VIEW IF EXISTS `query-fuzzy-output`;
CREATE VIEW `query-fuzzy-output` AS select `a`.`id` AS `id`,`a`.`bw` AS `bw`,`a`.`jml` AS `jml`,`a`.`serv` AS `serv`,`a`.`fz` AS `fz`,`a`.`min` AS `min`,`a`.`WA` AS `WA`,if(((`a`.`fuzzy` >= 0) and (`a`.`fuzzy` <= 10)),'Normal',if(((`a`.`fuzzy` > 10) and (`a`.`fuzzy` <= 100)),'Upgrade','')) AS `fuzzy_output` from `query-fuzzy-final` `a`;

-- ----------------------------
-- View structure for `view-network`
-- ----------------------------
DROP VIEW IF EXISTS `view-network`;
CREATE VIEW `view-network` AS select `a`.`net_id` AS `netid`,`a`.`node_id` AS `nodeid`,`b`.`nama_area` AS `area`,`d`.`fakultas` AS `fakultas`,`c`.`jurusan` AS `jurusan`,`a`.`bandwidth` AS `bw`,`a`.`jml_pelanggan` AS `jml`,`a`.`pelayanan` AS `serv` from (((`network` `a` left join `area` `b` on((`b`.`area_id` = `a`.`area_id`))) left join `jurusan` `c` on((`c`.`jurusan_id` = `a`.`jurusan_id`))) left join `fakultas` `d` on((`d`.`fakultas_id` = `b`.`fakultas_id`)));

-- ----------------------------
-- View structure for `view-network-fuzzy`
-- ----------------------------
DROP VIEW IF EXISTS `view-network-fuzzy`;
CREATE VIEW `view-network-fuzzy` AS select `view-network`.`netid` AS `netid`,`view-network`.`nodeid` AS `nodeid`,`view-network`.`area` AS `area`,`view-network`.`fakultas` AS `fakultas`,`view-network`.`jurusan` AS `jurusan`,`view-network`.`bw` AS `bw`,`view-network`.`jml` AS `jml`,`view-network`.`serv` AS `serv`,`query-fuzzy-output`.`fuzzy_output` AS `fuzzy_output` from (`view-network` join `query-fuzzy-output` on((`query-fuzzy-output`.`id` = `view-network`.`netid`)));


-- ----------------------------
-- View structure for `20-view-rulebase`
-- ----------------------------
DROP VIEW IF EXISTS `20-view-rulebase`;
CREATE VIEW `20-view-rulebase` AS select `a`.`netid` AS `netid`,`a`.`b` AS `b`,`a`.`jml` AS `j`,`a`.`serv` AS `s`,`b`.`ruleid` AS `ruleid`,`b`.`rulename` AS `rulename`,`b`.`bw` AS `bw`,`b`.`jml` AS `jml`,`b`.`serv` AS `serv`,`b`.`fz` AS `fz`,(select `query-rules`.`ruleid` from `query-rules` order by `query-rules`.`ruleid` limit 1) AS `min`,(select `query-rules`.`ruleid` from `query-rules` order by `query-rules`.`ruleid` desc limit 1) AS `max` from (`query-himpunan` `a` join `query-rules` `b`) where (((`b`.`bw` = convert(if((`a`.`bwmin` = 1),'Sedikit','') using latin1)) or (`b`.`bw` = convert(if((`a`.`bwmid` = 1),'Sedang','') using latin1)) or (`b`.`bw` = convert(if((`a`.`bwmax` = 1),'Banyak','') using latin1))) and ((`b`.`jml` = convert(if((`a`.`jmlmin` = 1),'Sedikit','') using latin1)) or (`b`.`jml` = convert(if((`a`.`jmlmid` = 1),'Sedang','') using latin1)) or (`b`.`jml` = convert(if((`a`.`jmlmax` = 1),'Banyak','') using latin1))) and ((`b`.`serv` = convert(if((`a`.`servmin` = 1),'Buruk','') using latin1)) or (`b`.`serv` = convert(if((`a`.`servmid` = 1),'Cukup','') using latin1)) or (`b`.`serv` = convert(if((`a`.`servmax` = 1),'Baik','') using latin1)))) group by `b`.`ruleid`;

-- ----------------------------
-- View structure for `21-view-minmax-rule`
-- ----------------------------
DROP VIEW IF EXISTS `21-view-minmax-rule`;
CREATE VIEW `21-view-minmax-rule` AS select `a`.`netid` AS `netid`,`a`.`ruleid` AS `ruleid`,`a`.`rulename` AS `rulename`,(select min(`20-view-rulebase`.`ruleid`) from `20-view-rulebase`) AS `rmin`,(select `20-view-rulebase`.`ruleid` from `20-view-rulebase` order by `20-view-rulebase`.`ruleid` desc limit 1) AS `rmax` from `20-view-rulebase` `a`;

-- ----------------------------
-- View structure for `22-view-rulebase`
-- ----------------------------
DROP VIEW IF EXISTS `22-view-rulebase`;
CREATE VIEW `22-view-rulebase` AS select `a`.`netid` AS `netid`,`a`.`b` AS `b`,`a`.`jml` AS `cmt`,`a`.`serv` AS `ck`,`b`.`ruleid` AS `ruleid`,`b`.`rulename` AS `rulename`,`b`.`bw` AS `bw`,`b`.`jml` AS `jml`,`b`.`serv` AS `serv`,`b`.`fz` AS `fz` from (`query-himpunan` `a` join `query-rules` `b`) where (((`b`.`bw` = convert(if((`a`.`bwmin` = 1),'Sedikit',0) using latin1)) or (`b`.`bw` = convert(if((`a`.`bwmid` = 1),'Sedang',0) using latin1)) or (`b`.`bw` = convert(if((`a`.`bwmax` = 1),'Banyak',0) using latin1))) and ((`b`.`jml` = convert(if((`a`.`jmlmin` = 1),'Sedikit',0) using latin1)) or (`b`.`jml` = convert(if((`a`.`jmlmid` = 1),'Sedang',0) using latin1)) or (`b`.`jml` = convert(if((`a`.`jmlmax` = 1),'Banyak',0) using latin1))) and ((`b`.`serv` = convert(if((`a`.`servmin` = 1),'Buruk',0) using latin1)) or (`b`.`serv` = convert(if((`a`.`servmid` = 1),'Cukup',0) using latin1)) or (`b`.`serv` = convert(if((`a`.`servmax` = 1),'Baik',0) using latin1)))) order by `a`.`netid`,`b`.`ruleid`;
