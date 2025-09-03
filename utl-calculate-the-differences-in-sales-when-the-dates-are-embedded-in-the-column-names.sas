%let pgm=utl-calculate-the-differences-in-sales-when-the-dates-are-embedded-in-the-column-names;

%stop_submission;

Calculate the differences in sales from the previous month when the dates are embedded in the column names;

SOLUTION BY
KSharp
https://communities.sas.com/t5/user/viewprofilepage/user-id/18408

PROBLEM
========

We want to compute then difference between current sales and the previous month.

If current date is 2021-01, we look for the column that has the previous month.
The previous month in this case is STOCK_202012, thus the difference we want
is

CURRENT      - PREVIOUS

STOCK_202101 - STOCK_202012 = 3


                                   BECAUE
CURRENT       STOCK_    STOCK_     CURRENT_DATE    PREVIOUS        OUTPUT
   DATE       202012    202101     IS 202001       MONTH

2021-01-10      20        23       STOCK_202101  - STOCK_202012 =   3
....

github
https://tinyurl.com/3e3mb7ch
https://github.com/rogerjdeangelis/utl-calculate-the-differences-in-sales-when-the-dates-are-embedded-in-the-column-names

communities sas
https://tinyurl.com/bde8vvu3
https://communities.sas.com/t5/SAS-Programming/How-to-calculate-the-differences-in-sales-at-different-reference/m-p/744609#M233285

/*                   _
(_)_ __  _ __  _   _| |_
| | `_ \| `_ \| | | | __|
| | | | | |_) | |_| | |_
|_|_| |_| .__/ \__,_|\__|
        |_|
*/

data have;
 input
  id
  date ddmmyy8.
  stock_202012
  stock_202101
  stock_202102
  stock_202103
  stock_202104;
 format date e8601da.;
cards4;
1 10012021 20 23 22 27 30
2 07042021 10 10 10 10 11
3 23022021 44 44 48 48 50
4 12042021 21 24 27 30 31
5 09022021 30 40 50 43 44
;;;;
run;

/**************************************************************************************************************************/
/*                      STOCK_    STOCK_    STOCK_    STOCK_    STOCK_                                                    */
/* ID       DATE       202012    202101    202102    202103    202104                                                     */
/*                                                                                                                        */
/*  1    2021-01-10      20        23        22        27        30                                                       */
/*  2    2021-04-07      10        10        10        10        11                                                       */
/*  3    2021-02-23      44        44        48        48        50                                                       */
/*  4    2021-04-12      21        24        27        30        31                                                       */
/*  5    2021-02-09      30        40        50        43        44                                                       */
/**************************************************************************************************************************/

/*
 _ __  _ __ ___   ___ ___  ___ ___
| `_ \| `__/ _ \ / __/ _ \/ __/ __|
| |_) | | | (_) | (_|  __/\__ \__ \
| .__/|_|  \___/ \___\___||___/___/
|_|
*/

data want;
 set have;
 cur_month_sales=vvaluex(cats('stock_',put(date,yymmn6.)));
 pre_month_sales=vvaluex(cats('stock_',put(intnx('month',date,-1),yymmn6.)));
 delta_sales=cur_month_sales-pre_month_sales;
run;

proc print data=want split='_';
run;quit;

/**************************************************************************************************************************/
/*                                                                    Take the difference                                 */
/*                                                                    -------------------                                 */
/*                                                                         CUR      PRE                                   */
/*                      STOCK     STOCK     STOCK     STOCK     STOCK    MONTH    MONTH    DELTA                          */
/* ID       DATE       202012    202101    202102    202103    202104    SALES    SALES    SALES                          */
/*                                                                                                                        */
/*  1    2021-01-10      20        23        22        27        30       23       20         3  23-20                    */
/*  2    2021-04-07      10        10        10        10        11       11       10         1  11-19                    */
/*  3    2021-02-23      44        44        48        48        50       48       44         4  48-44                    */
/*  4    2021-04-12      21        24        27        30        31       31       30         1  31-30                    */
/*  5    2021-02-09      30        40        50        43        44       50       40        10  50-40                    */
/**************************************************************************************************************************/

/*              _
  ___ _ __   __| |
 / _ \ `_ \ / _` |
|  __/ | | | (_| |
 \___|_| |_|\__,_|

*/
