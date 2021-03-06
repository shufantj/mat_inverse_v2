function load_project(handles, lang)
% LOAD PROJECT
% Load a project from file.
%
% Author: Pablo Pizarro @ppizarror.com, 2017.
%
% This program is free software; you can redistribute it and/or
% modify it under the terms of the GNU General Public License
% as published by the Free Software Foundation; either version 2
% of the License, or (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.

% Constant import
constants;
savefile_extension = strcat('*', savefile_extension); %#ok<NODEF>

% Set loading status and request file
set_status(handles, lang{81});
[baseName, folder] = uigetfile({savefile_extension, lang{78}}, lang{82}, ...
    getappdata(handles.root, 'last_opened_folder'));%#ok<*ASGLU>

% Warning counter
warn = 0;

% If filename is valid
if baseName ~= 0
    
    try
        
        % Loading project
        set_status(handles, lang{86});
        filename = strcat(folder, baseName);
        setappdata(handles.root, 'last_opened_folder', folder);
        set(handles.root, 'pointer', 'watch');
        load(filename, '-mat');
        
        % --------------------------------------------------------------------
        % Load initial table
        set(handles.initial_solution, 'Data', state.initial_table);
        set(handles.initial_solution, 'RowName', state.initial_table_rowname);
        
        % Load main variables
        setappdata(handles.root, 'disp_freq', state.disp_freq);
        setappdata(handles.root, 'disp_vrexp', state.disp_vrexp);
        setappdata(handles.root, 'dispersion_ok', state.dispersion_ok);
        setappdata(handles.root, 'dispersion_file', state.dispersion_file);
        setappdata(handles.root, 'initial_table_validsize', state.initial_table_validsize);
        setappdata(handles.root, 'n_iter', state.n_iter);
        setappdata(handles.root, 'max_iter_sol', state.max_iter_sol);
        setappdata(handles.root, 'vr_iter', state.vr_iter);
        setappdata(handles.root, 'vp_iter', state.vp_iter);
        setappdata(handles.root, 'vs_iter', state.vs_iter);
        setappdata(handles.root, 'dns_iter', state.dns_iter);
        setappdata(handles.root, 'solution_ok', state.solution_ok);
        setappdata(handles.root, 'thk_sol', state.thk_sol);
        setappdata(handles.root, 'vs_sol', state.vs_sol);
        setappdata(handles.root, 'vp_sol', state.vp_sol);
        setappdata(handles.root, 'dns_sol', state.dns_sol);
        setappdata(handles.root, 'project_loaded', state.project_loaded);
        setappdata(handles.root, 'project_savefile', strcat(folder, baseName));
        setappdata(handles.root, 'dispersion_file_short', state.dispersion_file_short);
        setappdata(handles.root, 'project_savefile_short', baseName);
        
        % Load inv entry
        set(handles.param_inv_sigma, 'string', state.inv_entry_sigma);
        set(handles.param_inv_mu, 'string', state.inv_entry_mu);
        set(handles.param_maxiter, 'string', state.inv_entry_maxiter);
        set(handles.param_tolvs, 'string', state.inv_entry_tolvs);
        
        % Load units
        set(handles.unit_vr, 'String', state.vr_units);
        set(handles.unit_vr, 'Value', state.unit_vr);
        set(handles.unit_vsvp, 'String', state.vsvp_units);
        set(handles.unit_vsvp, 'Value', state.unit_vsvp);
        set(handles.unit_h, 'String', state.h_units);
        set(handles.unit_h, 'Value', state.unit_h);
        set(handles.unit_rho, 'String', state.rho_units);
        set(handles.unit_rho, 'Value', state.unit_rho);
        
        % Plot dispersion curve if loaded
        if state.dispersion_ok
            
            set(handles.status_direction_file, 'string', state.dispersion_file_short);
            
            % --- Plot data
            axes(handles.plt_dispersion_file);
            plt_style = getappdata(handles.root, 'plt_dispersion_style');
            plot(state.disp_freq, state.disp_vrexp, plt_style);
            
            % Enable context menu
            set(handles.disp_plt_viewlarger, 'Enable', 'on');
            set(handles.dispersion_plt_viewtable, 'Enable', 'on');
            
            % Check if file already exists
            if ~exist(state.dispersion_file, 'file')
                [~, dispertion_file_name, dispertion_file_name_ext] = fileparts(state.dispersion_file);
                dispersion_filename = strcat(folder, strcat(dispertion_file_name, dispertion_file_name_ext));
                if ~exist(dispersion_filename, 'file')
                    disp_error(handles, lang, 93, dispersion_filename);
                    warn = warn + 1;
                else
                    setappdata(handles.root, 'dispersion_file', dispersion_filename);
                    
                    % Set short filename on gui
                    if length(dispersion_filename) > size_filename_dispersion_str
                        short_dispersion_filename = dispersion_filename(length(dispersion_filename)-size_filename_dispersion_str:end);
                        short_dispersion_filename = strcat('...', short_dispersion_filename);
                    else
                        short_dispersion_filename = dispersion_filename;
                    end
                    setappdata(handles.root, 'dispersion_file_short', short_dispersion_filename);
                    set(handles.status_direction_file, 'string', short_dispersion_filename);
                end
            end
            
        end
        
        % Set normal cursor
        set(handles.root, 'pointer', 'arrow');
        
        % Disable / Enable menu entries
        set(handles.menu_file_save, 'Enable', 'on');
        
        % Enable / Disable buttons
        set(handles.start_button, 'Enable', 'on');
        
        % Project loaded successfully
        if warn == 0
            set_status(handles, lang{87});
        else
            set_status(handles, sprintf(lang{94}, warn));
        end
        
        % If solution is OK
        if state.solution_ok
            
            % Enable view plot if solution is loaded
            set(handles.export_results, 'Enable', 'on');
            set(handles.view_sol_plot, 'Enable', 'on');
            
            % Write iteration number
            set(handles.status_iteration, 'string', sprintf(lang{58}, state.n_iter, ...
                state.max_iter_sol));
            set_lang_string(handles.start_button, lang{42}, 'string');
            
        else
            disable_sol(handles, lang);
        end
        
        % Set title of the app
        set_app_title(handles, lang);
        
    catch Exception
        
        % Get Exception message
        msg_error = getReport(Exception, 'basic', 'hyperlinks', 'off');
        if getappdata(handles.root, 'gui_sound')
            beep();
        end
        
        % Set new file
        new_file(handles, lang, false);
        
        % Display errors / set statuses
        set_status(handles, lang{84}, 'r');
        errordlg(msg_error, lang{61});
        
    end
    
    % Project not loaded
else
    disp_error(handles, lang, 83);
end

end

