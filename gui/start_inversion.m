function start_inversion(handles, lang)
% START INVERSION
% Starts the inversion calculus.
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

% Set status
set_status(handles, lang{48}, 'k');

% --- Input validation
set_status(handles, lang{49}, 'k');

% Check if inversion parameters are OK
inv_status = check_inv_parameters(handles, lang, true);
if ~ inv_status
    return
end

% Check if initial table is valid
initial_table_status = check_initial_table(handles, lang);
if ~ initial_table_status
    set_status(handles, lang{51}, 'r');
    errordlg(lang{51}, lang{23});
    return
end

% Check if dispertion properly loaded
dispertion_status = getappdata(handles.root, 'dispertion_ok');
if ~ dispertion_status
    set_status(handles, lang{50}, 'r');
    errordlg(lang{50}, lang{23});
    return
end

end