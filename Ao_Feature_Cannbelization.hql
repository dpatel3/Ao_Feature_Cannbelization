{\rtf1\ansi\ansicpg1252\cocoartf1561\cocoasubrtf200
{\fonttbl\f0\fnil\fcharset0 Menlo-Regular;}
{\colortbl;\red255\green255\blue255;\red0\green0\blue0;\red255\green255\blue255;\red38\green38\blue38;
\red242\green242\blue242;}
{\*\expandedcolortbl;;\cssrgb\c0\c0\c0;\cssrgb\c100000\c100000\c100000;\cssrgb\c20000\c20000\c20000;
\cssrgb\c96078\c96078\c96078;}
\margl1440\margr1440\vieww33400\viewh21000\viewkind0
\deftab720
\pard\pardeftab720\sl260\partightenfactor0

\f0\fs22 \cf2 \cb3 \expnd0\expndtw0\kerning0
********************************Script**************************************\cb1 \
\cb3 DROP TABLE IF EXISTS AO_Item_Recommendation.feature_ind;\cb1 \
\cb3 Create table AO_Item_Recommendation.feature_ind as\cb1 \
\cb3 select a.item_nbr, a.store_nbr, a.wm_year_nbr, a.
\fs20 wm_week_nbr,
\fs22 a.item_feature_ind,a.feature_ind,
\fs29\fsmilli14667 \cb1 \

\fs22 \cb3 b.wm_year_nbr as last_wmt_year,b.
\fs20 wm_week_nbr as last_week_nbr,
\fs22 b.item_feature_ind as last_feature_ind, b.feature_ind as Last_Yr_feature_ind
\fs29\fsmilli14667 \cb1 \

\fs22 \cb3 From fss_bin_latest.feature_names_fss_s01082018_2017_to_current_year_with_hist_plan a, \cb1 \
\cb3 fss_bin_latest.feature_names_fss_s01082018_2017_to_current_year_with_hist_plan b\cb1 \
\cb3 Where a.item_nbr=b.item_nbr\cb1 \
\cb3 And a.store_nbr=b.store_nbr\cb1 \
\cb3 And a.
\fs20 wm_week_nbr=b.wm_week_nbr
\fs29\fsmilli14667 \cb1 \
\pard\pardeftab720\sl220\partightenfactor0

\fs20 \cf2 \cb3 And a.
\fs22 wm_year_nbr=18 and a.feature_ind=1
\fs29\fsmilli14667 \cb1 \
\pard\pardeftab720\sl260\partightenfactor0

\fs22 \cf2 \cb3 And 
\fs20 b.
\fs22 wm_year_nbr=17 and b.feature_ind=0;
\fs29\fsmilli14667 \cb1 \

\fs22 \'a0\
\'a0\
\cb3 DROP TABLE IF EXISTS AO_Item_Recommendation.sku_dly_pos_avg;\cb1 \
\cb3 Create table AO_Item_Recommendation.sku_dly_pos_avg as\cb1 \
\cb3 Select a.item_nbr,a.store_nbr,a.wm_yr_wk,a.wkly_sales,Avg(a.sell_price) over (partition by a.item_nbr,a.store_nbr,a.wm_yr_wk) as price\cb1 \
\cb3 from wm_sales.sku_dly_pos a;\cb1 \
\'a0\
\'a0\
\cb3 DROP TABLE IF EXISTS AO_Item_Recommendation.pos_item;\cb1 \
\cb3 create table AO_Item_Recommendation.pos_item as\cb1 \
\cb3 Select a.item_nbr,a.store_nbr,a.price,a.wm_yr_wk,b.dept_nbr,b.dept_category_nbr,b.mds_fam_id,a.wkly_sales\cb1 \
\cb3 From AO_Item_Recommendation.sku_dly_pos_avg a,\cb1 \
\cb3 ww_core_dim_tables.ITEM_DIM b\cb1 \
\cb3 Where a.item_nbr=b.mds_fam_id\cb1 \
\cb3 and b.current_ind = 'Y' \cb1 \
\cb3 and b.base_div_nbr = 1 \cb1 \
\cb3 and b.country_code = 'US';\cb1 \
\'a0\
\'a0\
\cb3 DROP TABLE IF EXISTS AO_Item_Recommendation.wm_yr_wk_jn_can;\cb1 \
\cb3 create table AO_Item_Recommendation.wm_yr_wk_jn_can as\cb1 \
\cb3 Select distinct a.item_nbr,a.store_nbr,a.price,a.wm_yr_wk,a.dept_nbr,a.dept_category_nbr,a.mds_fam_id,\cb1 \
\cb3 b.fiscal_year_nbr, b.wm_week_nbr,b.wm_year_nbr,
\fs26 \cf4 \cb5 SUBSTR(
\fs22 \cf2 \cb3 wm_year_nbr,3,2) as sub_year, SUM(wkly_sales) over (partition by dept_nbr,dept_category_nbr,store_nbr,wm_year_nbr) AS total_cat_sale_per_st_year
\fs29\fsmilli14667 \cb1 \

\fs22 \cb3 From AO_Item_Recommendation.pos_item a,\cb1 \
\cb3 fss_latest_qa.fss_calendar_dim b\cb1 \
\cb3 Where a.wm_yr_wk=b.wm_yr_wk_id;\cb1 \
\pard\pardeftab720\sl220\partightenfactor0

\fs20 \cf2 \'a0\
\pard\pardeftab720\sl260\partightenfactor0

\fs22 \cf2 \'a0\
\cb3 DROP TABLE IF EXISTS AO_Item_Recommendation.Ao_feature_item_reco;\cb1 \
\cb3 create table AO_Item_Recommendation.Ao_feature_item_reco as\cb1 \
\cb3 Select distinct a.item_nbr,a.store_nbr,a.price,a.sub_year, a.wm_week_nbr,a.wm_yr_wk,a.total_cat_sale_per_st_year,\cb1 \
\cb3 b.wm_year_nbr,b.
\fs20 wm_week_nbr as week_nbr
\fs22 , b.feature_ind as curr_feat_ind,
\fs29\fsmilli14667 \cb1 \

\fs22 \cb3 b.Last_Yr_feature_ind\cb1 \
\cb3 From AO_Item_Recommendation.wm_yr_wk_jn_can a, \cb1 \
\cb3 \'a0\'a0\'a0\'a0 AO_Item_Recommendation.feature_ind b\cb1 \
\cb3 Where a.item_nbr=b.item_nbr\cb1 \
\cb3 And a.store_nbr=b.store_nbr\cb1 \
\cb3 And a.wm_week_nbr=b.wm_week_nbr\cb1 \
\cb3 And a.sub_year=b.wm_year_nbr\cb1 \
\cb3 and sub_year=18\cb1 \
\cb3 Union\cb1 \
\cb3 Select distinct a.item_nbr,a.store_nbr,a.price,a.sub_year,a.wm_week_nbr,a.wm_yr_wk, a.total_cat_sale_per_st_year,\cb1 \
\cb3 b.last_wmt_year as wm_year_nbr,b.
\fs20 wm_week_nbr as week_nbr
\fs22 , b.feature_ind as curr_feat_ind, b.Last_Yr_feature_ind
\fs29\fsmilli14667 \cb1 \

\fs22 \cb3 From AO_Item_Recommendation.wm_yr_wk_jn_can a, \cb1 \
\cb3 \'a0\'a0\'a0\'a0 AO_Item_Recommendation.feature_ind b\cb1 \
\cb3 Where a.item_nbr=b.item_nbr\cb1 \
\cb3 And a.store_nbr=b.store_nbr\cb1 \
\cb3 And a.wm_week_nbr=b.wm_week_nbr\cb1 \
\cb3 And a.sub_year=b.last_wmt_year\cb1 \
\cb3 and sub_year=17;\cb1 \
\'a0\
\'a0\
\cb3 DROP TABLE IF EXISTS AO_Item_Recommendation.Ao_feature_item_case;\cb1 \
\cb3 Create table AO_Item_Recommendation.Ao_feature_item_case as\cb1 \
\cb3 select a.item_nbr, a.store_nbr, a.wm_year_nbr, a.
\fs20 wm_week_nbr,a.price,a.
\fs22 wm_yr_wk,a.total_cat_sale_per_st_year as total_cat_sale_per_st_year_2018,
\fs29\fsmilli14667 \cb1 \

\fs22 \cb3 b.wm_year_nbr as last_wmt_year,b.
\fs20 wm_week_nbr as last_week_nbr, b.price as last_year_price, b.
\fs22 total_cat_sale_per_st_year\'a0 as total_cat_sale_per_st_year_2017
\fs29\fsmilli14667 \cb1 \

\fs22 \cb3 From AO_Item_Recommendation.Ao_feature_item_reco a, \cb1 \
\cb3 \'a0\'a0\'a0\'a0 AO_Item_Recommendation.Ao_feature_item_reco b\cb1 \
\cb3 Where a.item_nbr=b.item_nbr\cb1 \
\cb3 And a.store_nbr=b.store_nbr\cb1 \
\cb3 And a.
\fs20 wm_week_nbr=b.wm_week_nbr
\fs29\fsmilli14667 \cb1 \
\pard\pardeftab720\sl220\partightenfactor0

\fs20 \cf2 \cb3 And a.
\fs22 wm_year_nbr=18 
\fs29\fsmilli14667 \cb1 \
\pard\pardeftab720\sl260\partightenfactor0

\fs22 \cf2 \cb3 And 
\fs20 b.
\fs22 wm_year_nbr=17;
\fs29\fsmilli14667 \cb1 \

\fs22 \'a0\
\'a0\
\cb3 DROP TABLE IF EXISTS AO_Item_Recommendation.cnt_item_Cat_St_can;\cb1 \
\cb3 CREATE TABLE AO_Item_Recommendation.cnt_item_Cat_St_can AS\cb1 \
\cb3 Select tab.cnt_item_per_dept_cat_store,y.*\cb1 \
\cb3 from\cb1 \
\cb3 (Select count(x.item_nbr) over (partition by x.store_nbr,x.dept_nbr,x.dept_category_nbr) as cnt_item_per_dept_cat_store,\cb1 \
\cb3 x.*\cb1 \
\cb3 FROM\cb1 \
\cb3 (Select distinct c.item_nbr,c.store_nbr,c.dept_nbr,c.dept_category_nbr\cb1 \
\cb3 From AO_Item_Recommendation.wm_yr_wk_jn_can c)x)tab,\cb1 \
\cb3 AO_Item_Recommendation.wm_yr_wk_jn_can y\cb1 \
\cb3 Where tab.item_nbr=y.item_nbr and\cb1 \
\cb3 Tab.store_nbr=y.store_nbr and\cb1 \
\cb3 Tab.dept_nbr=y.dept_nbr and\cb1 \
\cb3 Tab.dept_category_nbr=y.dept_category_nbr;\cb1 \
\'a0\
\'a0\
\'a0\
\cb3 DROP TABLE IF EXISTS AO_Item_Recommendation.Ao_Item_Reco;\cb1 \
\cb3 CREATE TABLE AO_Item_Recommendation.Ao_Item_Reco AS\cb1 \
\cb3 Select a.*, b.cnt_item_per_dept_cat_store,b.dept_nbr,b.dept_category_nbr\cb1 \
\cb3 From Ao_feature_item_case a,\cb1 \
\cb3 cnt_item_Cat_St_can b\cb1 \
\cb3 Where a.item_nbr=b.item_nbr\cb1 \
\cb3 And a.store_nbr=b.store_nbr\cb1 \
\cb3 And a.wm_yr_wk=b.wm_yr_wk;\cb1 \
}