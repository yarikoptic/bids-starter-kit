%% Template Matlab script to create an BIDS compatible electrodes.tsv file
% This example lists all required and optional fields.
% When adding additional metadata please use CamelCase
%
% DHermes, 2017
% modified Giulio Castegnaro 201811

% Writing json files relies on the JSONio library
% https://github.com/bids-standard/bids-matlab
%
% Make sure it is in the matab/octave path
try
    bids.bids_matlab_version;
catch
    warning('%s\n%s\n%s\n%s', ...
            'Writing the JSON file seems to have failed.', ...
            'Make sure that the following library is in the matlab/octave path:', ...
            'https://github.com/bids-standard/bids-matlab');
end

%%
clear;

this_dir = fileparts(mfilename('fullpath'));
root_dir = fullfile(this_dir, '..', filesep, '..');

project = 'templates';

sub_label = '01';
ses_label = '01';

name_spec.modality = 'ieeg';
name_spec.suffix = 'electrodes';
name_spec.ext = '.tsv';
name_spec.entities = struct('sub', sub_label, ...
                            'ses', ses_label);

% using the 'use_schema', true
% ensures that the entities will be in the correct order
bids_file = bids.File(name_spec, 'use_schema', true);

% Contrust the fullpath version of the filename
electrodes_tsv_name = fullfile(root_dir, project, bids_file.bids_path, bids_file.filename);

%% make a participants table and save

%% required columns
name = {''}; % Name of the electrode contact point
x = [0]'; % X position. The positions of the center of each electrode in xyz space.
% Units are in millimeters or pixels and are specified in _*space-<label>_electrode.json.
y = [0]'; % Y position.
z = [0]'; % Z position. If electrodes are in 2D space this should be a column of n/a values.
Size = [0]'; % Surface area in mm^2

%% recommended columns
material = {''}; % Material of the electrodes
manufacturer = {''}; % Optional field to specify the electrode manufacturer
% for each electrode. Can be used if electrodes were manufactured by more than one company.
group = {''}; % Optional field to specify the group that the electrode is a part of.
% Note that any group specified here should match a group specified in `_channels.tsv`
hemisphere = {''}; % Optional field to specify the hemisphere in which
% the electrode is placed, one of ["L" or "R"] (use capital).

%% optional columns
type = {''}; % Optional type of the electrode,for example:cup, ring, clip-on, wire, needle, ...
impedance = {''}; % Impedance of the electrode in kOhm.

%% write
t = table(name, x, y, z, Size, material, manufacturer, group, hemisphere, type, impedance);

writetable(t, electrodes_tsv_name, 'FileType', 'text', 'Delimiter', '\t');

clear Size;
