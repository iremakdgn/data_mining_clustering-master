function varargout = veri_madenciligi_proje(varargin)

gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @VERI_MADENCILIGI_proje_OpeningFcn, ...
                   'gui_OutputFcn',  @VERI_MADENCILIGI_proje_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end

function VERI_MADENCILIGI_proje_OpeningFcn(hObject, eventdata, handles, varargin)
guidata(hObject, handles);
data = Dataset;
axes(handles.benzerlik_figur);
affinity = CalculateAffinity(data);
imagesc(affinity);
axes(handles.giris_figur);
plot(handles.giris_figur,data(:,1),data(:,2),'.');
set(handles.giris_figur,'XMinorTick','on');
set(handles.dataset_table, 'Visible', 'off');
set(handles.dbscan_k_str,'visible','off');
set(handles.dbscan_eps_str,'visible','off');
set(handles.dbscan_k,'visible','off');
set(handles.dbscan_eps,'visible','off');
set(handles.sse_title,'Visible','off')
set(handles.sse_value,'Visible','off')
set(handles.dataset_table,'Data', data);

function varargout = VERI_MADENCILIGI_proje_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function verisetleri_Callback(hObject, eventdata, handles)

val = get(hObject,'Value');

        data = Dataset;
    
        data_file = uigetfile('C:\Users\irem_\Desktop\diabetes-data\Diabetes-Data')
       mfilename, '(''clear_traj'')']);
            eval(['load ' data_file]);
            tmp = find(data_file=='.');
            if tmp == []
                eval(['data=' data_file ';']);
            else
                eval(['data=' data_file(1:tmp-1) ';']);
            end
            if size(data, 2) ~= 2,
                fprintf('Given data is not 2-D!\n');
                no_change = 1;
            end
        end

end

affinity = CalculateAffinity(data);
axes(handles.benzerlik_figur);
imagesc(affinity);
set(handles.dataset_table,'Data', data);
axes(handles.giris_figur);
plot(handles.giris_figur,data(:,1),data(:,2),'.');
set(handles.giris_figur,'XMinorTick','on')

function verisetleri_CreateFcn(hObject, eventdata, handles)

a='Dataset 1';
s=char(a,b,c,d,e,f,g,h);
set(hObject,'String',s);
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function algoritmalar_Callback(hObject, eventdata, handles)
function algoritmalar_CreateFcn(hObject, eventdata, handles)

a='K-Means';b='Gauss';c='Fuzzy C-Means';d='Complete Link';e='DBSCAN';
s=char(a,b,c,d,e);
set(hObject,'String',s);
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function calistir_Callback(hObject, eventdata, handles)

data = get(handles.dataset_table,'Data');
algoritma_val = get(handles.algoritmalar,'Value');
kume_sayisi = double(get(handles.kume_sayisi,'Value'));


switch algoritma_val
    case 1
        tic;
        [cidx,~,sumd]=kmeans(data,kume_sayisi);
        sse_value=sse(sumd);
        calisma_suresi = toc;
        axes(handles.cikis_figur);
        scatter(data(:,1),data(:,2),15,cidx,'filled')
        set(handles.cikis_figur,'XMinorTick','on')
        set(handles.sse_value,'String',sse_value);
        set(handles.sse_title,'Visible','on')
        set(handles.sse_value,'Visible','on')
    case 2
        % gaussian
        tic;
        gauss = gmdistribution.fit(data,kume_sayisi,'Regularize', 1e-5);
        cidx = cluster(gauss,data);
        calisma_suresi = toc;
        axes(handles.cikis_figur);
        scatter(data(:,1),data(:,2),15,cidx,'filled')
        set(handles.cikis_figur,'XMinorTick','on')
    case 3
        % fcm
        tic;
        [~,U,~] = fcm(data,kume_sayisi);
        cidx=zeros(length(data),1);
        for i=1:kume_sayisi
        index= find(U(i, :) == max(U));
           for k=1:length(index)
                cidx(index(k))=i;
           end 
        end
        calisma_suresi = toc;
        axes(handles.cikis_figur);
        scatter(data(:,1),data(:,2),15,cidx,'filled')
        set(handles.cikis_figur,'XMinorTick','on')
    case 4
        tic;
        Z = linkage(data,'ward','euclidean');
        c = cluster(Z,'maxclust',kume_sayisi);
        calisma_suresi = toc;
        axes(handles.cikis_figur);
        scatter(data(:,1),data(:,2),15,c,'filled') 
        set(handles.cikis_figur,'XMinorTick','on')
    case 5
        k = str2double(get(handles.dbscan_k,'String'));
        eps = str2double(get(handles.dbscan_eps,'String'));
        if isnan(eps)
            eps = [];
        end
        tic;
        [cidx,type]=dbscan(data,k,eps);
        calisma_suresi = toc;
        axes(handles.cikis_figur);
        scatter(data(:,1),data(:,2),15,cidx,'filled')
        set(handles.cikis_figur,'XMinorTick','on')
        set(handles.dbscan_k_str,'Visible','on')
        set(handles.dbscan_k,'Visible','on')
        set(handles.dbscan_eps_str,'Visible','on')
        set(handles.dbscan_eps,'Visible','on')
end
set(handles.calisma_suresi,'String',num2str(calisma_suresi,6));
if algoritma_val ~= 5
    set(handles.dbscan_k_str,'Visible','off')
    set(handles.dbscan_k,'Visible','off')
    set(handles.dbscan_eps_str,'Visible','off')
    set(handles.dbscan_eps,'Visible','off')
end
if algoritma_val ~= 1
    set(handles.sse_title,'Visible','off')
    set(handles.sse_value,'Visible','off')
end




function kume_sayisi_Callback(hObject, eventdata, handles)

function kume_sayisi_CreateFcn(hObject, eventdata, handles)

a='1';b='2';c='3';d='4';e='5';f='6';g='7';h='8';j='9';k='10';
s=char(a,b,c,d,e,f,g,h,j,k);
set(hObject,'String',s);
set(hObject,'Value',2);

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function dbscan_k_Callback(hObject, eventdata, handles)

function dbscan_k_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function dbscan_eps_Callback(hObject, eventdata, handles)

function dbscan_eps_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
