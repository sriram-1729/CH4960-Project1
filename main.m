% CH4960 Project 1
% Submitted by Kinjarapu Sriram CH18B010

%% Initializing the random number generator
rng(299792458);

%% Fixing the number of Generation A neutrons
N_a = 1e4;

%% Generating RND1
xx_RND1 = 0:1:1e7;
w_RND1 = 0.771.*sqrt(xx_RND1./1e6).*exp(-0.776*xx_RND1./1e6);
RND1 = randsample(xx_RND1, N_a, true, w_RND1);
RND1 = RND1/1e6;

%% Finding out the atomic ratio of the different types of elements present
A_U_fr = pi*(5e-1)^2;
A_Zr_fr = pi*((5.5e-1)^2-(5e-1)^2);
A_Zr_b = (212e-1)^2-(210e-1)^2;
A_U = 196*A_U_fr;
A_Zr = 196*A_Zr_fr+A_Zr_b;
A_w = (222e-1)^2-(A_U+A_Zr);

n_U = A_U*19.1/238.02891;
n_Zr = A_Zr*6.52/91.224;
n_w = A_w*0.9970474/18.01528;
n_U235 = 0.03*n_U;
n_U238 = 0.97*n_U;
n_H = 2*n_w;
n_O = n_w;

%% Generating RND2
w_RND2 = [n_H n_O n_U238 n_Zr n_U235];
w_RND2 = w_RND2/sum(w_RND2);
xx_RND2 = [1 2 3 4 5];
RND2 = randsample(xx_RND2, N_a, true, w_RND2);

%% Cross section data

% Fission data
U235_fission_data = readmatrix('data/U235/U235-fission.csv');
U238_fission_data = readmatrix('data/U238/U238-fission.csv');

% Capture data
H_capture_data = readmatrix('data/H1/H1-capture.csv');
H_capture_data(:, 1) = H_capture_data(:, 1)/1e6;
O_capture_data = readmatrix('data/O16/O16-capture.csv');
O_capture_data(:, 1) = O_capture_data(:, 1)/1e6;
U238_capture_data = readmatrix('data/U238/U238-capture.csv');
U238_capture_data(:, 1) = U238_capture_data(:, 1)/1e6;
Zr_capture_data = readmatrix('data/Zr90/Zr90-capture.csv');
Zr_capture_data(:, 1) = Zr_capture_data(:, 1)/1e6;
U235_capture_data = readmatrix('data/U235/U235-capture.csv');
U235_capture_data(:, 1) = U235_capture_data(:, 1)/1e6;

% Scattering (elastic) data
H_scattering_data = readmatrix('data/H1/H1-scattering.csv');
O_scattering_data = readmatrix('data/O16/O16-scattering.csv');
U238_scattering_data = readmatrix('data/U238/U238-scattering.csv');
Zr_scattering_data = readmatrix('data/Zr90/Zr90-scattering.csv');
U235_scattering_data = readmatrix('data/U235/U235-scattering.csv');

%% Determining number of Generation B neutrons produced

N_b = 0;
i = 1;

while i <= N_a
    
    if(RND1(i) < 1e-9)
        i = i + 1;
        continue
    end
    
    switch RND2(i)
        case 1
            if RND1(i) < H_scattering_data(1, 1)
                scattering_cs = H_scattering_data(1,2);
            else
                scattering_cs = H_scattering_data(2, 2);
            end
            
            fission_cs = 0;
            
            for j = 1:size(H_capture_data, 1)
                if H_capture_data(j, 1) > RND1(i)
                    capture_cs = H_capture_data(j, 2);
                end
            end
            
            alpha = 0;
            
        case 2
            for j = 1:size(O_scattering_data, 1)
                if O_scattering_data(j, 1) > RND1(i)
                    scattering_cs = O_scattering_data(j, 2);
                end
            end

            fission_cs = 0;
            
            for j = 1:size(O_capture_data, 1)
                if O_capture_data(j, 1) > RND1(i)
                    capture_cs = O_capture_data(j, 2);
                end
            end
            
            alpha = (15/17)^2;
            
        case 3
            for j = 1:size(U238_scattering_data, 1)
                if U238_scattering_data(j, 1) > RND1(i)
                    scattering_cs = U238_scattering_data(j, 2);
                end
            end
            
            for j = 1:size(U238_fission_data, 1)
                if U238_fission_data(j, 1) > RND1(i)
                    fission_cs = U238_fission_data(j, 2);
                end
            end
            
            for j = 1:size(U238_capture_data, 1)
                if U238_capture_data(j, 1) > RND1(i)
                    capture_cs = U238_capture_data(j, 2);
                end
            end
            
            alpha = (237/239)^2;
            
        case 4
            if RND1(i) < Zr_scattering_data(1, 1)
                scattering_cs = Zr_scattering_data(1,2);
            else
                scattering_cs = Zr_scattering_data(2, 2);
            end
            
            fission_cs = 0;
            
            for j = 1:size(Zr_capture_data, 1)
                if Zr_capture_data(j, 1) > RND1(i)
                    capture_cs = Zr_capture_data(j, 2);
                end
            end
            
            alpha = (89/91)^2;
            
        case 5
            scattering_cs = U235_scattering_data(7, 2);
            for j = 1:size(U235_scattering_data, 1)
                if U235_scattering_data(j, 1) > RND1(i)
                    scattering_cs = U235_scattering_data(j, 2);
                end
            end
            
            for j = 1:size(U235_fission_data, 1)
                if U235_fission_data(j, 1) > RND1(i)
                    fission_cs = U235_fission_data(j, 2);
                end
            end
            
            for j = 1:size(U235_capture_data, 1)
                if U235_capture_data(j, 1) > RND1(i)
                    capture_cs = U235_capture_data(j, 2);
                end
            end
            
            alpha = (234/236)^2;
    end
    
    % Generating RND3
    w_RND3 = [scattering_cs fission_cs capture_cs];
    
    % This ensures that only fast neutrons cause fission with U-238
    if RND2(i) == 3 && RND1(i) < 0.01
        w_RND3(2) = 0;
    elseif RND2(i) == 5 && RND1(i) > 1e-6
        w_RND3(2) = 0;
    end
    
    w_RND3 = w_RND3/sum(w_RND3);
    xx_RND3 = [1 2 3];
    RND3 = randsample(xx_RND3, 1, true, w_RND3);
    
    if RND3 == 1
        if alpha ~= 0
            xi = 1+(alpha/(1-alpha))*log(alpha);
        else
            xi = 1;
        end
        
        RND1(i) = RND1(i)*exp(-xi);
        RND2(i) = randsample(xx_RND2, 1, true, w_RND2);
        
    elseif RND3 == 3
        i = i + 1;
        
    else
        if RND2(i) == 3
            N_b = N_b + 2.819;
            i = i + 1;
        elseif RND2(i) == 5
            N_b = N_b + 2.4355;
            i = i + 1;
        end
    end
end

%% Finding out the infinite multiplication factor
k = N_b/N_a;
fprintf("Multiplication factor = %.2f\n", k);