 nls_c1_fn = load('nls_roc_det\nls_c1_fn_arr.txt');
 nls_c1_fp = load('nls_roc_det\nls_c1_fp_arr.txt');
 nls_c1_tp = load('nls_roc_det\nls_c1_tp_arr.txt');
 nls_c2_fn = load('nls_roc_det\nls_c2_fn_arr.txt');
 nls_c2_fp = load('nls_roc_det\nls_c2_fp_arr.txt');
 nls_c2_tp = load('nls_roc_det\nls_c2_tp_arr.txt');
 nls_c3_fn = load('nls_roc_det\nls_c3_fn_arr.txt');
 nls_c3_fp = load('nls_roc_det\nls_c3_fp_arr.txt');
 nls_c3_tp = load('nls_roc_det\nls_c3_tp_arr.txt');
 nls_c4_fn = load('nls_roc_det\nls_c4_fn_arr.txt');
 nls_c4_fp = load('nls_roc_det\nls_c4_fp_arr.txt');
 nls_c4_tp = load('nls_roc_det\nls_c4_tp_arr.txt');
 nls_c5_fn = load('nls_roc_det\nls_c5_fn_arr.txt');
 nls_c5_fp = load('nls_roc_det\nls_c5_fp_arr.txt');
 nls_c5_tp = load('nls_roc_det\nls_c5_tp_arr.txt');
 
%plotting ROC
figure
plot(nls_c1_fp,nls_c1_tp);
hold on
plot(nls_c2_fp,nls_c2_tp);
hold on
plot(nls_c3_fp,nls_c3_tp);
hold on
plot(nls_c4_fp,nls_c4_tp);
hold on
plot(nls_c5_fp,nls_c5_tp);
title('ROC');
legend('case 1','case 2','case 3','case 4','case 5');
%plotting DET
figure
plot(nls_c1_fp,nls_c1_fn);
hold on
plot(nls_c2_fp,nls_c2_fn);
hold on
plot(nls_c3_fp,nls_c3_fn);
hold on
plot(nls_c4_fp,nls_c4_fn);
hold on
plot(nls_c5_fp,nls_c5_fn);
title('DET');
legend('case 1','case 2','case 3','case 4','case 5');