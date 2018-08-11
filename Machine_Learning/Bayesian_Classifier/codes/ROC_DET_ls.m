 ls_c1_fn = load('ls_roc_det\ls_c1_fn_arr.txt');
 ls_c1_fp = load('ls_roc_det\ls_c1_fp_arr.txt');
 ls_c1_tp = load('ls_roc_det\ls_c1_tp_arr.txt');
 ls_c2_fn = load('ls_roc_det\ls_c2_fn_arr.txt');
 ls_c2_fp = load('ls_roc_det\ls_c2_fp_arr.txt');
 ls_c2_tp = load('ls_roc_det\ls_c2_tp_arr.txt');
 ls_c3_fn = load('ls_roc_det\ls_c3_fn_arr.txt');
 ls_c3_fp = load('ls_roc_det\ls_c3_fp_arr.txt');
 ls_c3_tp = load('ls_roc_det\ls_c3_tp_arr.txt');
 ls_c4_fn = load('ls_roc_det\ls_c4_fn_arr.txt');
 ls_c4_fp = load('ls_roc_det\ls_c4_fp_arr.txt');
 ls_c4_tp = load('ls_roc_det\ls_c4_tp_arr.txt');
 ls_c5_fn = load('ls_roc_det\ls_c5_fn_arr.txt');
 ls_c5_fp = load('ls_roc_det\ls_c5_fp_arr.txt');
 ls_c5_tp = load('ls_roc_det\ls_c5_tp_arr.txt');
 
%plotting ROC
figure
plot(ls_c1_fp,ls_c1_tp);
hold on
plot(ls_c2_fp,ls_c2_tp);
hold on
plot(ls_c3_fp,ls_c3_tp);
hold on
plot(ls_c4_fp,ls_c4_tp);
hold on
plot(ls_c5_fp,ls_c5_tp);
title('ROC');
legend('case 1','case 2','case 3','case 4','case 5');
%plotting DET
figure
plot(ls_c1_fp,ls_c1_fn);
hold on
plot(ls_c2_fp,ls_c2_fn);
hold on
plot(ls_c3_fp,ls_c3_fn);
hold on
plot(ls_c4_fp,ls_c4_fn);
hold on
plot(ls_c5_fp,ls_c5_fn);
title('DET');
legend('case 1','case 2','case 3','case 4','case 5');