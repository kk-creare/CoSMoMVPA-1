%% Dataset Basics
% Run operations on datasets
%

% Load data as before setting targets and chunks appropriately

% >>
ds = cosmo_fmri_dataset([data_path '/glm_T_stats_perrun.nii.gz'], ...
                        'mask', [data_path '/vt_mask.nii.gz']);

% set targets
ds.sa.targets = repmat([1:6]',10,1);

% set chunks
chunks = [];
for i=1:10 chunks = [chunks; repmat(i,6,1)]; end
ds.sa.chunks = chunks;
% <<

% select the sample indices that correspond to primates and bugs

% >>
primate_idx = boolean(repmat([1 1 0 0 0 0]',10,1));
bug_idx = boolean(repmat([0 0 0 0 1 1]',10,1));
% <<

% use the indices as input to the dataset samples slicer

% >>
primate_ds = cosmo_dataset_slice_sa(ds, primate_idx);
bug_ds = cosmo_dataset_slice_sa(ds, bug_idx);
% <<                    

% Find the mean pattern for primates and bugs and subtract the bug pattern from
% the primate pattern

% >>
primates_mean = mean(primate_ds.samples, 1);
bugs_mean = mean(bug_ds.samples, 1);
primates_minus_bugs = primates_mean - bugs_mean;
% <<

% Finally save the result as a dataset with the original header
% Just replace ds.samples with the result. Convert back to nifti and save it
% using cosmo_map2nifti function.

% >>
ds.samples = primate_minus_bugs;
ni = cosmo_map2nifti(ds, [data_path '/primates_minus_bugs.nii.gz'])

% View the result using AFNI, FSL, or Matlab's imagesc

imagesc(ni.hdr(:,:,4));

%<<
