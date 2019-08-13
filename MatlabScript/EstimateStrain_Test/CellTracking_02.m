%Import Strain-corrected stack of images (cum_reg_stack)
load('F:\tobi\ImStack_StrainCorrected_Frame120-210_08.01.2019_1_hTC_P268_p8_d5_+AA_S2__2.mat')
thresh = multithresh(cum_reg_stack, 2);
cum_reg_stack_log = cum_reg_stack >= thresh(end);
for iframe = 1:size(cum_reg_stack, 3)
    curr_im_log = cum_reg_stack_log(:,:,iframe);
    nhood = [1 1 1; 1 1 1; 1 1 1];
    curr_im_log = imerode(curr_im_log, nhood);
%     bwlabeln(cum_reg_stack_log);
    cum_reg_stack_log(:,:,iframe) = curr_im_log;
end