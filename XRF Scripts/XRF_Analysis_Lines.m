clear all;
close all;
clc;
%% Initialize variables.
files = dir('*.mca');

yMin=1;
yMax=2000;

xMin= 0;
xMax=26;
elements = {'Fe', 'Cr', 'Ni', 'Mo'};



%%ELEMENTS
% name
% start energy
% end energy

lines= {
'Li'	0.054	'K\alpha'	150
'Be'	0.109	'K\alpha'	150
'B'     0.183	'K\alpha'	151
'C'     0.277	'K\alpha'	147
'Sc'	0.348	'Ll'	21
'N'     0.392	'K\alpha'	150
'Ti'	0.395	'Ll'	46
'Sc'	0.395	'L\alpha'	111
'Sc'	0.400	'L\beta'	77
'V'     0.447	'Ll'	28
'Ti'	0.452	'L\alpha'	111
'Ti'	0.458	'L\beta'	79
'Cr'	0.500	'Ll'	17
'V'     0.511	'L\alpha'	111
'V'     0.519	'L\beta'	80
'O'     0.525	'K\alpha'	151
'Mn'	0.556	'Ll'	15
'Cr'	0.573	'L\alpha'	111
'Cr'	0.583	'L\beta'	79
'Fe'	0.615	'Ll'	10
'Mn'	0.637	'L\alpha'	111
'Mn'	0.649	'L\beta'	77
'F'     0.677	'K\alpha'	148
'Co'	0.678	'Ll'	10
'Fe'	0.705	'L\alpha'	111
'Fe'	0.719	'L\beta'	66
'Ni'	0.743	'Ll'	9
'Co'	0.776	'L\alpha'	111
'Co'	0.791	'L\beta'	76
'Cu'	0.811	'Ll'	8
'La'	0.833	'M\alpha'	100
'Ne'	0.849	'K\alpha'	150
'Ni'	0.852	'L\alpha'	111
'Ni'	0.869	'L\beta'	68
'Ce'	0.883	'M\alpha'	100
'Zn'	0.884	'Ll'	7
'Pr'	0.929	'M\alpha'	100
'Cu'	0.930	'L\alpha'	111
'Cu'	0.950	'L\beta'	65
'Ga'	0.957	'Ll'	7
'Nd'	0.978	'M\alpha'	100
'Zn'	1.012	'L\alpha'	111
'Zn'	1.035	'L\beta'	65
'Ge'	1.036	'Ll'	6
'Na'	1.041	'K\alpha'	150
'Sm'	1.081	'M\alpha'	100
'Ga'	1.098	'L\alpha'	111
'As'	1.120	'Ll'	6
'Ga'	1.125	'L\beta'	66
'Eu'	1.131	'M\alpha'	100
'Gd'	1.185	'M\alpha'	100
'Ge'	1.188	'L\alpha'	111
'Se'	1.204	'Ll'	6
'Ge'	1.219	'L\beta'	60
'Tb'	1.240	'M\alpha'	100
'Mg'	1.254	'K\alpha'	150
'As'	1.282	'L\alpha'	111
'Dy'	1.293	'M\alpha'	100
'Br'	1.294	'Ll'	5
'As'	1.317	'L\beta'	60
'Ho'	1.348	'M\alpha'	100
'Se'	1.379	'L\alpha'	111
'Kr'	1.386	'Ll'	5
'Er'	1.406	'M\alpha'	100
'Se'	1.419	'L\beta'	59
'Tm'	1.462	'M\alpha'	100
'Br'	1.480	'L\alpha'	111
'Rb'	1.482	'Ll'	5
'Al'	1.486	'K\alpha2'	50
'Al'	1.487	'K\alpha'	100
'Yb'	1.521	'M\alpha'	100
'Br'	1.526	'L\beta'	59
'Al'	1.557	'K\beta'	1
'Lu'	1.581	'M\alpha'	100
'Sr'	1.582	'Ll'	5
'Kr'	1.586	'L\alpha'	111
'Kr'	1.637	'L\beta'	57
'Hf'	1.645	'M\alpha'	100
'Y'     1.685	'Ll'	5
'Rb'	1.693	'L\alpha2'	11
'Rb'	1.694	'L\alpha'	100
'Ta'	1.710	'M\alpha'	100
'Si'	1.739	'K\alpha2'	50
'Si'	1.740	'K\alpha'	100
'Rb'	1.752	'L\beta'	58
'W'     1.775	'M\alpha'	100
'Zr'	1.792	'Ll'	5
'Sr'	1.805	'L\alpha2'	11
'Sr'	1.807	'L\alpha'	100
'Si'	1.836	'K\beta'	2
'Re'	1.843	'M\alpha'	100
'Sr'	1.872	'L\beta'	58
'Nb'	1.902	'Ll'	5
'Os'	1.910	'M\alpha'	100
'Y'     1.921	'L\alpha2'	11
'Y'     1.923	'L\alpha'	100
'Ir'	1.980	'M\alpha'	100
'Y'     1.996	'L\beta'	57
'P'     2.013	'K\alpha2'	50
'P'     2.014	'K\alpha'	100
'Mo'	2.016	'Ll'	5
'Zr'	2.040	'L\alpha2'	11
'Zr'	2.042	'L\alpha'	100
'Pt'	2.051	'M\alpha'	100
'Tc'	2.122	'Ll'	5
'Au'	2.123	'M\alpha'	100
'Zr'	2.124	'L\beta'	54
'P'     2.139	'K\beta'	3
'Nb'	2.163	'L\alpha2'	11
'Nb'	2.166	'L\alpha'	100
'Hg'	2.195	'M\alpha'	100
'Zr'	2.219	'L\beta2'	1
'Ru'	2.253	'Ll'	4
'Nb'	2.257	'L\beta'	52
'Tl'	2.271	'M\alpha'	100
'Mo'	2.290	'L\alpha2'	11
'Mo'	2.293	'L\alpha'	100
'Zr'	2.303	'Lg'	2
'S'     2.307	'K\alpha2'	50
'S'     2.308	'K\alpha'	100
'Pb'	2.346	'M\alpha'	100
'Nb'	2.367	'L\beta2'	3
'Rh'	2.377	'Ll'	4
'Mo'	2.395	'L\beta'	53
'Tc'	2.420	'L\alpha2'	11
'Bi'	2.423	'M\alpha'	100
'Tc'	2.424	'L\alpha'	100
'Nb'	2.462	'Lg'	2
'S'     2.464	'K\beta'	5
'Pd'	2.503	'Ll'	4
'Mo'	2.518	'L\beta2'	5
'Tc'	2.538	'L\beta'	54
'Ru'	2.554	'L\alpha2'	11
'Ru'	2.559	'L\alpha'	100
'Cl'	2.621	'K\alpha2'	50
'Cl'	2.622	'K\alpha'	100
'Mo'	2.624	'Lg'	3
'Ag'	2.634	'Ll'	4
'Tc'	2.674	'L\beta2'	7
'Ru'	2.683	'L\beta'	54
'Rh'	2.692	'L\alpha2'	11
'Rh'	2.697	'L\alpha'	100
'Cd'	2.767	'Ll'	4
'Tc'	2.792	'Lg'	3
'Cl'	2.816	'K\beta'	6
'Pd'	2.833	'L\alpha2'	11
'Rh'	2.834	'L\beta'	52
'Ru'	2.836	'L\beta2'	10
'Pd'	2.839	'L\alpha'	100
'In'	2.904	'Ll'	4
'Ar'	2.956	'K\alpha2'	50
'Ar'	2.958	'K\alpha'	100
'Ru'	2.965	'Lg'	4
'Ag'	2.978	'L\alpha2'	11
'Ag'	2.984	'L\alpha'	100
'Pd'	2.990	'L\beta'	53
'Th'	2.996	'M\alpha'	100
'Rh'	3.001	'L\beta2'	10
'Sn'	3.045	'Ll'	4
'Cd'	3.127	'L\alpha2'	11
'Cd'	3.134	'L\alpha'	100
'Rh'	3.144	'Lg'	5
'Ag'	3.151	'L\beta'	56
'U'     3.171	'M\alpha'	100
'Pd'	3.172	'L\beta2'	12
'Sb'	3.189	'Ll'	4
'Ar'	3.191	'K\beta'	10
'In'	3.279	'L\alpha2'	11
'In'	3.287	'L\alpha'	100
'K'     3.311	'K\alpha2'	50
'K'     3.314	'K\alpha'	100
'Cd'	3.317	'L\beta'	58
'Pd'	3.329	'Lg'	6
'Te'	3.336	'Ll'	4
'Ag'	3.348	'L\beta2'	13
'Sn'	3.435	'L\alpha2'	11
'Sn'	3.444	'L\alpha'	100
'I'     3.485	'Ll'	4
'In'	3.487	'L\beta'	58
'Ag'	3.520	'Lg'	6
'Cd'	3.528	'L\beta2'	15
'K'     3.590	'K\beta'	11
'Sb'	3.595	'L\alpha2'	11
'Sb'	3.605	'L\alpha'	100
'Xe'	3.636	'Ll'	4
'Sn'	3.663	'L\beta'	60
'Ca'	3.688	'K\alpha2'	50
'Ca'	3.692	'K\alpha'	100
'In'	3.714	'L\beta2'	15
'Cd'	3.717	'Lg'	6
'Te'	3.759	'L\alpha2'	11
'Te'	3.769	'L\alpha'	100
'Cs'	3.795	'Ll'	4
'Sb'	3.844	'L\beta'	61
'Sn'	3.905	'L\beta2'	16
'In'	3.921	'Lg'	6
'I'     3.926	'L\alpha2'	11
'I'     3.938	'L\alpha'	100
'Ba'	3.954	'Ll'	4
'Ca'	4.013	'K\beta'	13
'Te'	4.030	'L\beta'	61
'Sc'	4.086	'K\alpha2'	50
'Sc'	4.091	'K\alpha'	100
'Xe'	4.093	'L\alpha2'	11
'Sb'	4.101	'L\beta2'	17
'Xe'	4.110	'L\alpha'	100
'La'	4.124	'Ll'	4
'Sn'	4.131	'Lg'	7
'I'     4.221	'L\beta'	61
'Cs'	4.272	'L\alpha2'	11
'Cs'	4.287	'L\alpha'	100
'Ce'	4.288	'Ll'	4
'Te'	4.302	'L\beta2'	18
'Sb'	4.348	'Lg'	8
'Xe'	4.414	'L\beta'	60
'Ba'	4.451	'L\alpha2'	11
'Pr'	4.453	'Ll'	4
'Sc'	4.461	'K\beta'	15
'Ba'	4.466	'L\alpha'	100
'Ti'	4.505	'K\alpha2'	50
'I'     4.508	'L\beta2'	19
'Ti'	4.511	'K\alpha'	100
'Te'	4.571	'Lg'	8
'Cs'	4.620	'L\beta'	61
'Nd'	4.633	'Ll'	4
'La'	4.634	'L\alpha2'	11
'La'	4.651	'L\alpha'	100
'Xe'	4.714	'L\beta2'	20
'I'     4.801	'Lg'	8
'Pm'	4.809	'Ll'	4
'Ce'	4.823	'L\alpha2'	11
'Ba'	4.828	'L\beta'	60
'Ce'	4.840	'L\alpha'	100
'Ti'	4.932	'K\beta'	15
'Cs'	4.936	'L\beta2'	20
'V'     4.945	'K\alpha2'	50
'V'     4.952	'K\alpha'	100
'Sm'	4.995	'Ll'	4
'Pr'	5.014	'L\alpha2'	11
'Pr'	5.034	'L\alpha'	100
'Xe'	5.034	'Lg'	8
'La'	5.042	'L\beta'	60
'Ba'	5.157	'L\beta2'	20
'Eu'	5.177	'Ll'	4
'Nd'	5.208	'L\alpha2'	11
'Nd'	5.230	'L\alpha'	100
'Ce'	5.262	'L\beta'	61
'Cs'	5.280	'Lg'	8
'Gd'	5.362	'Ll'	4
'La'	5.384	'L\beta2'	21
'Cr'	5.406	'K\alpha2'	50
'Pm'	5.408	'L\alpha2'	11
'Cr'	5.415	'K\alpha'	100
'V'     5.427	'K\beta'	15
'Pm'	5.432	'L\alpha'	100
'Pr'	5.489	'L\beta'	61
'Ba'	5.531	'Lg'	9
'Tb'	5.547	'Ll'	4
'Sm'	5.609	'L\alpha2'	11
'Ce'	5.613	'L\beta2'	21
'Sm'	5.636	'L\alpha'	100
'Nd'	5.722	'L\beta'	60
'Dy'	5.743	'Ll'	4
'La'	5.789	'Lg'	9
'Eu'	5.817	'L\alpha2'	11
'Eu'	5.846	'L\alpha'	100
'Pr'	5.850	'L\beta2'	21
'Mn'	5.888	'K\alpha2'	50
'Mn'	5.899	'K\alpha'	100
'Ho'	5.943	'Ll'	4
'Cr'	5.947	'K\beta'	15
'Pm'	5.961	'L\beta'	61
'Gd'	6.025	'L\alpha2'	11
'Ce'	6.052	'Lg'	9
'Gd'	6.057	'L\alpha'	100
'Nd'	6.089	'L\beta2'	21
'Er'	6.152	'Ll'	4
'Sm'	6.205	'L\beta'	61
'Tb'	6.238	'L\alpha2'	11
'Tb'	6.273	'L\alpha'	100
'Pr'	6.322	'Lg'	9
'Pm'	6.339	'L\beta2'	21
'Tm'	6.342	'Ll'	4
'Fe'	6.391	'K\alpha2'	50
'Fe'	6.404	'K\alpha'	100
'Eu'	6.456	'L\beta'	62
'Dy'	6.458	'L\alpha2'	11
'Mn'	6.490	'K\beta'	17
'Dy'	6.495	'L\alpha'	100
'Yb'	6.546	'Ll'	4
'Sm'	6.587	'L\beta2'	21
'Nd'	6.602	'Lg'	10
'Ho'	6.680	'L\alpha2'	11
'Gd'	6.713	'L\beta'	62
'Ho'	6.720	'L\alpha'	100
'Lu'	6.753	'Ll'	4
'Eu'	6.843	'L\beta2'	21
'Pm'	6.892	'Lg'	10
'Er'	6.905	'L\alpha2'	11
'Co'	6.915	'K\alpha2'	51
'Co'	6.930	'K\alpha'	100
'Er'	6.949	'L\alpha'	100
'Hf'	6.960	'Ll'	5
'Tb'	6.978	'L\beta'	61
'Fe'	7.058	'K\beta'	17
'Gd'	7.103	'L\beta2'	21
'Tm'	7.133	'L\alpha2'	11
'Ta'	7.173	'Ll'	5
'Sm'	7.178	'Lg'	10
'Tm'	7.180	'L\alpha'	100
'Dy'	7.248	'L\beta'	62
'Tb'	7.367	'L\beta2'	21
'Yb'	7.367	'L\alpha2'	11
'W'     7.388	'Ll'	5
'Yb'	7.416	'L\alpha'	100
'Ni'	7.461	'K\alpha2'	51
'Ni'	7.478	'K\alpha'	100
'Eu'	7.480	'Lg'	10
'Ho'	7.525	'L\beta'	64
'Re'	7.604	'Ll'	5
'Lu'	7.605	'L\alpha2'	11
'Dy'	7.636	'L\beta2'	20
'Co'	7.649	'K\beta'	17
'Lu'	7.656	'L\alpha'	100
'Gd'	7.786	'Lg'	11
'Er'	7.811	'L\beta'	64
'Os'	7.822	'Ll'	5
'Hf'	7.845	'L\alpha2'	11
'Hf'	7.899	'L\alpha'	100
'Ho'	7.911	'L\beta2'	20
'Cu'	8.028	'K\alpha2'	51
'Ir'	8.046	'Ll'	5
'Cu'	8.048	'K\alpha'	100
'Ta'	8.088	'L\alpha2'	11
'Tm'	8.101	'L\beta'	64
'Tb'	8.102	'Lg'	11
'Ta'	8.146	'L\alpha'	100
'Er'	8.189	'L\beta2'	20
'Ni'	8.265	'K\beta'	17
'Pt'	8.268	'Ll'	5
'W'     8.335	'L\alpha2'	11
'W'     8.398	'L\alpha'	100
'Yb'	8.402	'L\beta'	65
'Dy'	8.419	'Lg'	11
'Tm'	8.468	'L\beta2'	20
'Au'	8.494	'Ll'	5
'Re'	8.586	'L\alpha2'	11
'Zn'	8.616	'K\alpha2'	51
'Zn'	8.639	'K\alpha'	100
'Re'	8.653	'L\alpha'	100
'Lu'	8.709	'L\beta'	66
'Hg'	8.721	'Ll'	5
'Ho'	8.747	'Lg'	11
'Yb'	8.759	'L\beta2'	20
'Os'	8.841	'L\alpha2'	11
'Cu'	8.905	'K\beta'	17
'Os'	8.912	'L\alpha'	100
'Tl'	8.953	'Ll'	6
'Hf'	9.023	'L\beta'	67
'Lu'	9.049	'L\beta2'	19
'Er'	9.089	'Lg'	11
'Ir'	9.100	'L\alpha2'	11
'Ir'	9.175	'L\alpha'	100
'Pb'	9.185	'Ll'	6
'Ga'	9.225	'K\alpha2'	51
'Ga'	9.252	'K\alpha'	100
'Ta'	9.343	'L\beta'	67
'Hf'	9.347	'L\beta2'	20
'Pt'	9.362	'L\alpha2'	11
'Bi'	9.420	'Ll'	6
'Tm'	9.426	'Lg'	12
'Pt'	9.442	'L\alpha'	100
'Zn'	9.572	'K\beta'	17
'Au'	9.628	'L\alpha2'	11
'Ta'	9.652	'L\beta2'	20
'W'     9.672	'L\beta'	67
'Au'	9.713	'L\alpha'	100
'Yb'	9.780	'Lg'	12
'Ge'	9.855	'K\alpha2'	51
'Ge'	9.886	'K\alpha'	100
'Hg'	9.898	'L\alpha2'	11
'W'     9.962	'L\beta2'	21
'Hg'	9.989	'L\alpha'	100
'Re'	10.010	'L\beta'	66
'Lu'	10.143	'Lg'	12
'Tl'	10.173	'L\alpha2'	11
'Ga'	10.260	'K\beta3'	5
'Ga'	10.264	'K\beta'	66
'Tl'	10.269	'L\alpha'	100
'Re'	10.275	'L\beta2'	22
'Os'	10.355	'L\beta'	67
'Pb'	10.450	'L\alpha2'	11
'As'	10.508	'K\alpha2'	51
'Hf'	10.516	'Lg'	12
'As'	10.544	'K\alpha'	100
'Pb'	10.552	'L\alpha'	100
'Os'	10.599	'L\beta2'	22
'Ir'	10.708	'L\beta'	66
'Bi'	10.731	'L\alpha2'	11
'Bi'	10.839	'L\alpha'	100
'Ta'	10.895	'Lg'	12
'Ir'	10.920	'L\beta2'	22
'Ge'	10.978	'K\beta3'	6
'Ge'	10.982	'K\beta'	60
'Pt'	11.071	'L\beta'	67
'Th'	11.119	'Ll'	6
'Se'	11.181	'K\alpha2'	52
'Se'	11.222	'K\alpha'	100
'Pt'	11.251	'L\beta2'	23
'W'	11.286	'Lg'	13
'Au'	11.442	'L\beta'	67
'Au'	11.585	'L\beta2'	23
'U'	11.618	'Ll'	7
'Re'	11.685	'Lg'	13
'As'	11.720	'K\beta3'	6
'As'	11.726	'K\beta'	13
'Hg'	11.823	'L\beta'	67
'As'	11.864	'K\beta2'	1
'Br'	11.878	'K\alpha2'	52
'Hg'	11.924	'L\beta2'	24
'Br'	11.924	'K\alpha'	100
'Os'	12.095	'Lg'	13
'Tl'	12.213	'L\beta'	67
'Tl'	12.272	'L\beta2'	25
'Se'	12.490	'K\beta3'	6
'Se'	12.496	'K\beta'	13
'Ir'	12.513	'Lg'	13
'Kr'	12.598	'K\alpha2'	52
'Pb'	12.614	'L\beta'	66
'Pb'	12.623	'L\beta2'	25
'Kr'	12.649	'K\alpha'	100
'Se'	12.652	'K\beta2'	1
'Th'	12.810	'L\alpha2'	11
'Pt'	12.942	'Lg'	13
'Th'	12.969	'L\alpha'	100
'Bi'	12.980	'L\beta2'	25
'Bi'	13.024	'L\beta'	67
'Br'	13.285	'K\beta3'	7
'Br'	13.291	'K\beta'	14
'Rb'	13.336	'K\alpha2'	52
'Au'	13.382	'Lg'	13
'Rb'	13.395	'K\alpha'	100
'U'	13.439	'L\alpha2'	11
'Br'	13.470	'K\beta2'	1
'U'	13.615	'L\alpha'	100
'Hg'	13.830	'Lg'	14
'Sr'	14.098	'K\alpha2'	52
'Kr'	14.104	'K\beta3'	7
'Kr'	14.112	'K\beta'	14
'Sr'	14.165	'K\alpha'	100
'Tl'	14.292	'Lg'	14
'Kr'	14.315	'K\beta2'	2
'Pb'	14.764	'Lg'	14
'Y'	14.883	'K\alpha2'	52
'Rb'	14.952	'K\beta3'	7
'Y'	14.958	'K\alpha'	100
'Rb'	14.961	'K\beta'	14
'Rb'	15.185	'K\beta2'	2
'Bi'	15.248	'Lg'	14
'Th'	15.624	'L\beta2'	26
'Zr'	15.691	'K\alpha2'	52
'Zr'	15.775	'K\alpha'	100
'Sr'	15.825	'K\beta3'	7
'Sr'	15.836	'K\beta'	14
'Sr'	16.085	'K\beta2'	3
'Th'	16.202	'L\beta'	69
'U'	16.428	'L\beta2'	26
'Nb'	16.521	'K\alpha2'	52
'Nb'	16.615	'K\alpha'	100
'Y'	16.726	'K\beta3'	8
'Y'	16.738	'K\beta'	15
'Y'	17.015	'K\beta2'	3
'U'	17.220	'L\beta'	61
'Mo'	17.374	'K\alpha2'	52
'Mo'	17.479	'K\alpha'	100
'Zr'	17.654	'K\beta3'	8
'Zr'	17.668	'K\beta'	15
'Zr'	17.970	'K\beta2'	3
'Tc'	18.251	'K\alpha2'	53
'Tc'	18.367	'K\alpha'	100
'Nb'	18.606	'K\beta3'	8
'Nb'	18.623	'K\beta'	15
'Nb'	18.953	'K\beta2'	3
'Th'	18.983	'Lg'	16
'Ru'	19.150	'K\alpha2'	53
'Ru'	19.279	'K\alpha'	100
'Mo'	19.590	'K\beta3'	8
'Mo'	19.608	'K\beta'	15
'Mo'	19.965	'K\beta2'	3
'Rh'	20.074	'K\alpha2'	53
'U'	    20.167	'Lg'	15
'Rh'	20.216	'K\alpha'	100
'Tc'	20.599	'K\beta3'	8
'Tc'	20.619	'K\beta'	16
'Tc'	21.005	'K\beta2'	4
'Pd'	21.020	'K\alpha2'	53
'Pd'	21.177	'K\alpha'	100
'Ru'	21.635	'K\beta3'	8
'Ru'	21.657	'K\beta'	16
'Ag'	21.990	'K\alpha2'	53
'Ru'	22.074	'K\beta2'	4
'Ag'	22.163	'K\alpha'	100
'Rh'	22.699	'K\beta3'	8
'Rh'	22.724	'K\beta'	16
'Cd'	22.984	'K\alpha2'	53
'Rh'	23.173	'K\beta2'	4
'Cd'	23.174	'K\alpha'	100
'Pd'	23.791	'K\beta3'	8
'Pd'	23.819	'K\beta'	16
'In'	24.002	'K\alpha2'	53
'In'	24.210	'K\alpha'	100
'Pd'	24.299	'K\beta2'	4
'Ag'	24.912	'K\beta3'	9
'Ag'	24.942	'K\beta'	16
'Sn'	25.044	'K\alpha2'	53
'Sn'	25.271	'K\alpha'	100
'Ag'	25.456	'K\beta2'	4
'Cd'	26.061	'K\beta3'	9
'Cd'	26.096	'K\beta'	17
'Sb'	26.111	'K\alpha2'	54
'Sb'	26.359	'K\alpha'	100
'Cd'	26.644	'K\beta2'	4
'Te'	27.202	'K\alpha2'	54
'In'	27.238	'K\beta3'	9
'In'	27.276	'K\beta'	17
'Te'	27.472	'K\alpha'	100
'In'	27.861	'K\beta2'	5
'I'	    28.317	'K\alpha2'	54
'Sn'	28.444	'K\beta3'	9
'Sn'	28.486	'K\beta'	17
'I'	    28.612	'K\alpha'	100
'Sn'	29.109	'K\beta2'	5
'Xe'	29.458	'K\alpha2'	54
'Sb'	29.679	'K\beta3'	9
'Sb'	29.726	'K\beta'	18
'Xe'	29.779	'K\alpha'	100
'Sb'	30.390	'K\beta2'	5
'Cs'	30.625	'K\alpha2'	54
'Te'	30.944	'K\beta3'	9
'Cs'	30.973	'K\alpha'	100
'Te'	30.996	'K\beta'	18
'Te'	31.700	'K\beta2'	5
'Ba'	31.817	'K\alpha2'	54
'Ba'	32.194	'K\alpha'	100
'I'	    32.239	'K\beta3'	9
'I'	    32.295	'K\beta'	18
'La'	33.034	'K\alpha2'	54
'I'	    33.042	'K\beta2'	5
'La'	33.442	'K\alpha'	100
'Xe'	33.562	'K\beta3'	9
'Xe'	33.624	'K\beta'	18
'Ce'	34.279	'K\alpha2'	55
'Xe'	34.415	'K\beta2'	5
'Ce'	34.720	'K\alpha'	100
'Cs'	34.919	'K\beta3'	9
'Cs'	34.987	'K\beta'	18
'Pr'	35.550	'K\alpha2'	55
'Cs'	35.822	'K\beta2'	6
'Pr'	36.026	'K\alpha'	100
'Ba'	36.304	'K\beta3'	10
'Ba'	36.378	'K\beta'	18
'Nd'	36.847	'K\alpha2'	55
'Ba'	37.257	'K\beta2'	6
'Nd'	37.361	'K\alpha'	100
'La'	37.720	'K\beta3'	10
'La'	37.801	'K\beta'	19
'Pm'	38.171	'K\alpha2'	55
'Pm'	38.725	'K\alpha'	100
'La'	38.730	'K\beta2'	6
'Ce'	39.170	'K\beta3'	10
'Ce'	39.257	'K\beta'	19
'Sm'	39.522	'K\alpha2'	55
'Sm'	40.118	'K\alpha'	100
'Ce'	40.233	'K\beta2'	6
'Pr'	40.653	'K\beta3'	10
'Pr'	40.748	'K\beta'	19
'Eu'	40.902	'K\alpha2'	56
'Eu'	41.542	'K\alpha'	100
'Pr'	41.773	'K\beta2'	6
'Nd'	42.167	'K\beta3'	10
'Nd'	42.271	'K\beta'	19
'Gd'	42.309	'K\alpha2'	56
'Gd'	42.996	'K\alpha'	100
'Nd'	43.335	'K\beta2'	6
'Pm'	43.713	'K\beta3'	10
'Tb'	43.744	'K\alpha2'	56
'Pm'	43.826	'K\beta'	19
'Tb'	44.482	'K\alpha'	100
'Pm'	44.942	'K\beta2'	6
'Dy'	45.208	'K\alpha2'	56
'Sm'	45.289	'K\beta3'	10
'Sm'	45.413	'K\beta'	19
'Dy'	45.998	'K\alpha'	100
'Sm'	46.578	'K\beta2'	6
'Ho'	46.700	'K\alpha2'	56
'Eu'	46.904	'K\beta3'	10
'Eu'	47.038	'K\beta'	19
'Ho'	47.547	'K\alpha'	100
'Er'	48.221	'K\alpha2'	56
'Eu'	48.256	'K\beta2'	6
'Gd'	48.555	'K\beta3'	10
'Gd'	48.697	'K\beta'	20
'Er'	49.128	'K\alpha'	100
'Tm'	49.773	'K\alpha2'	57
'Gd'	49.959	'K\beta2'	7
'Tb'	50.229	'K\beta3'	10
'Tb'	50.382	'K\beta'	20
'Tm'	50.742	'K\alpha'	100
'Yb'	51.354	'K\alpha2'	57
'Tb'	51.698	'K\beta2'	7
'Dy'	51.957	'K\beta3'	10
'Dy'	52.119	'K\beta'	20
'Yb'	52.389	'K\alpha'	100
'Lu'	52.965	'K\alpha2'	57
'Dy'	53.476	'K\beta2'	7
'Ho'	53.711	'K\beta3'	11
'Ho'	53.877	'K\beta'	20
'Lu'	54.070	'K\alpha'	100
'Hf'	54.611	'K\alpha2'	57
'Ho'	55.293	'K\beta2'	7
'Er'	55.494	'K\beta3'	11
'Er'	55.681	'K\beta'	21
'Hf'	55.790	'K\alpha'	100
'Ta'	56.277	'K\alpha2'	57
'Er'	57.210	'K\beta2'	7
'Tm'	57.304	'K\beta3'	11
'Tm'	57.517	'K\beta'	21
'Ta'	57.532	'K\alpha'	100
'W'	    57.982	'K\alpha2'	58
'Tm'	59.090	'K\beta2'	7
'Yb'	59.140	'K\beta3'	11
'W'	    59.318	'K\alpha'	100
'Yb'	59.370	'K\beta'	21
'Re'	59.718	'K\alpha2'	58
'Yb'	60.980	'K\beta2'	7
'Lu'	61.050	'K\beta3'	11
'Re'	61.140	'K\alpha'	100
'Lu'	61.283	'K\beta'	21
'Os'	61.487	'K\alpha2'	58
'Lu'	62.970	'K\beta2'	7
'Hf'	62.980	'K\beta3'	11
'Os'	63.001	'K\alpha'	100
'Hf'	63.234	'K\beta'	22
'Ir'	63.287	'K\alpha2'	58
'Ir'	64.896	'K\alpha'	100
'Ta'	64.949	'K\beta3'	11
'Hf'	64.980	'K\beta2'	7
'Pt'	65.112	'K\alpha2'	58
'Ta'	65.223	'K\beta'	22
'Pt'	66.832	'K\alpha'	100
'W'	    66.951	'K\beta3'	11
'Au'	66.990	'K\alpha2'	59
'Ta'	66.990	'K\beta2'	7
'W'	    67.244	'K\beta'	22
'Au'	68.804	'K\alpha'	100
'Hg'	68.895	'K\alpha2'	59
'Re'	68.994	'K\beta3'	12
'W'	    69.067	'K\beta2'	8
'Re'	69.310	'K\beta'	22
'Hg'	70.819	'K\alpha'	100
'Tl'	70.832	'K\alpha2'	60
'Os'	71.077	'K\beta3'	12
'Re'	71.232	'K\beta2'	8
'Os'	71.413	'K\beta'	23
'Pb'	72.804	'K\alpha2'	60
'Tl'	72.872	'K\alpha'	100
'Ir'	73.203	'K\beta3'	12
'Os'	73.363	'K\beta2'	8
'Ir'	73.561	'K\beta'	23
'Bi'	74.815	'K\alpha2'	60
'Pb'	74.969	'K\alpha'	100
'Pt'	75.368	'K\beta3'	12
'Ir'	75.575	'K\beta2'	8
'Pt'	75.748	'K\beta'	23
'Bi'	77.108	'K\alpha'	100
'Au'	77.580	'K\beta3'	12
'Pt'	77.850	'K\beta2'	8
'Au'	77.984	'K\beta'	23
'Hg'	79.822	'K\beta3'	12
'Au'	80.150	'K\beta2'	8
'Hg'	80.253	'K\beta'	23
'Tl'	82.118	'K\beta3'	12
'Hg'	82.515	'K\beta2'	8
'Tl'	82.576	'K\beta'	23
'Pb'	84.450	'K\beta3'	12
'Tl'	84.910	'K\beta2'	8
'Pb'	84.936	'K\beta'	23
'Bi'	86.834	'K\beta3'	12
'Pb'	87.320	'K\beta2'	8
'Bi'	87.343	'K\beta'	23
'Bi'	89.830	'K\beta2'	9
'Th'	89.953	'K\alpha2'	62
'Th'	93.350	'K\alpha'	100
'U'	    94.665	'K\alpha2'	62
'U'	    98.439	'K\alpha'	100
'Th'	104.831	'K\beta3'	12
'Th'	105.609	'K\beta'	24
'Th'	108.640	'K\beta2'	9
'U'	    110.406	'K\beta3'	13
'U'	    111.300	'K\beta'	24
'U'	    114.530	'K\beta2'	9
  };


% ELEMENTS = {
%     'Au(Ma)' 'Ni(Ka)' 'Cu(Ka)' 'Cu(Kb)' 'Au(La)' 'Au(Lb)';
%     2.01 7.29 7.81 8.73 9.58 11.36;
%     2.27 7.63 8.28 9.05 9.84  11.66
%     };

% ELEMENTS = {
%      'Ni(Ka)' 'Au(La)' 'Cu(Ka)';
%      7.29 9.58 7.81;
%      7.63 9.84 8.15
%      };


%  ELEMENTS = {
%       'Pb(La)' 'Pb(L{Beta})';
%       10.30 12.50;
%       10.73 12.78
%       };
 
h.figure = figure;
clf
position = get(gcf,'Position');
set(h.figure,'Color','w',...
    'PaperPositionMode', 'auto', ...
    'Units','in','Position',[position(1:2) 6 2.5 ],...
    'PaperPosition',[0.25 0.25 6 2.5])

myStyle = hgexport('factorystyle');
myStyle.Format = 'png';
myStyle.Width = 6;
myStyle.Height = 2.5;
myStyle.Resolution = 300;
myStyle.Units = 'inch';
myStyle.FixedFontSize = 12;
 figure('Position', [100, 100, 1200, 600]);
for file = files'
    
   % clearvars -except results files file lines elements xMin xMax yMin yMax
    delimiter = ' ';
    formatSpec = '%s%s%s%[^\n\r]';
    %% Open the text file.
    fileID = fopen(file.name,'r');
    
    dataArray = textscan(fileID, formatSpec, 'Delimiter', delimiter, 'MultipleDelimsAsOne', true, 'EmptyValue' ,NaN, 'ReturnOnError', false);
    
    %% Close the text file.
    fclose(fileID);
    
    %% Allocate imported array to column variable names
    XRF = dataArray{:, 1};
    index = strcmp(dataArray{:,1}, 'START_TIME');
    date =  dataArray{1,3}(index);
    
    index = find(strcmp(XRF, '<<DATA>>'));
    XRF = cellfun(@str2num, XRF(index+1:index+2048));
    %energy=(0:length(XRF)-1)';
    %energy=energy*0.012755-0.054841;
    energy= (1:length(XRF))';
    
    load('Blank.mat');
    %XRF=XRF-Blank;
    %smoothed = smooth(XRF,7);
    %baselineAdjusted = msbackadj(energy,smoothed,'WINDOWSIZE',150,'STEPSIZE',40);
    %baselineAdjustedTight = msbackadj(energy,smoothed,'WINDOWSIZE',17,'STEPSIZE',9);
    %baselineAdjustedWide = msbackadj(energy,smoothed,'WINDOWSIZE',150,'STEPSIZE',50);
    %baselineAdjusted(223:307)=baselineAdjustedWide(223:307);
    %baselineAdjusted(308:419)=baselineAdjustedTight(308:419);
    %energy=energy*0.0127627-0.0583363;
    baselineAdjusted=XRF;
    energy=energy*0.0127627-0.0583363;
    K=sum(baselineAdjusted(246:278))/1000;
    scaling = 1000/K;
    %K=K*scaling;
    fig=true;
    if fig
       
        hold on
        lb=find(energy>1.3,1, 'first');
        ub=find(energy>1.7,1, 'first');
        yMax=750;
        %baselineAdjusted = baselineAdjusted./yMax;
        
        H=area(energy, baselineAdjusted,1);
        H(1).FaceColor = [0.55 0.55 1.0];
        %set(gca,'YScale','log')
        %plot(energy,baselineAdjusted,'k');

        ylim([yMin 1.2*yMax]);
        xlim([xMin xMax]);
        %ylim([0 500])
        ax = gca;
        set(ax,'XTick',xMin:1.0:xMax)
        xlabel('Energy (keV)')
        ylabel('Count')
        title(file.name,'fontweight','bold','fontsize',20);
        hold off
       h1=text(0,0,'');
       hflip = 1;
        for i=54:length(lines)
            if(cell2mat(lines(i,2))>xMax)
                break;
            end
            if(cell2mat(lines(i,2))>xMin && ~isempty(elements(strcmp(elements, cell2mat(lines(i,1))))))
                if(cell2mat(lines(i,4))>5 && isempty(strfind(cell2mat(lines(i,3)),'Ll')) && isempty(strfind(cell2mat(lines(i,3)),'2')))
                    h2=text(cell2mat(lines(i,2)),min(1.02*baselineAdjusted(find(energy>=cell2mat(lines(i,2)),1))),strcat(cell2mat(lines(i,1)),'_{',cell2mat(lines(i,3)),'}'),'Color','black','fontweight','normal','FontSize',7,'HorizontalAlignment','Center','VerticalAlignment','bottom');
                    h1E=h1.Extent;
                    h2E=h2.Extent;
                    h2P=h2.Position;
                    if(h1E(1)+h1E(3)>h2E(1)&&h1E(4)>h2E(2))
                        
                        h2.Position=[h2P(1) h2P(2)-1.0*(h2E(2)-(h1E(2)+h1E(4))) 0]
                       
                            %h2.Position=[h2P(1) h2P(2)+1.0*(h2E(2)-(h1E(2)+h1E(4))) 0]
                        
                    end
                    h1=h2;
                end
            end
        end 
        set(gca,'LooseInset',get(gca,'TightInset'))
        shg
        hold on

        
    end
    %     %csvwrite(strcat,results(:,2:12));
    %     c=horzcat(energy,XRF,smoothed,baselineAdjusted);
    %     fid = fopen(strcat(file.name,'.csv'), 'w') ;
    %     fprintf(fid, '%s,%s,%s,%s\n', 'Energy (keV)','Count','Smoothed','BaselineAdjusted');
    %     fprintf(fid, '%s,', c(1,1:end-1)) ;
    %     fprintf(fid, '%s\n', c(1,end)) ;
    %     fclose(fid) ;
    %     dlmwrite(strcat(file.name,'.csv'), c(2:end,:), '-append') ;
    %     %plot(energy,XRF,energy,baselineAdjusted, energy,XRF-baselineAdjusted)
    filen=file.name;
    filen=filen(1:end-4);
      %  hgexport(gcf,strcat(filen,'.png'),hgexport('factorystyle'),'Format','png')
    %    set(gcf,'PaperOrientation','landscape');
%print(gcf, '-fillpage', '-dpdf', strcat(file.name,'.pdf'));
    
   % close all
end

%figure('units','normalized','outerposition',[0 0 1 1])
%plot(energy,baselineAdjusted,'LineWidth',1.5)
%plot(energy,XRF,energy,baselineAdjusted, energy,smoothed-baselineAdjusted)
%xlim([0 15])
%ylim([0 max(baselineAdjusted)*1.05])
%ax = gca;
%set(ax,'XTick',0.0:1.0:15.0)
%xlabel('Energy (keV)')
%ylabel('Count')
%title(file.name,'fontweight','bold','fontsize',16);

%csvwrite('results.csv',results(:,2:12));
%c=results(:,2:12);
%fid = fopen('results.csv', 'w') ;
%fprintf(fid, '%s\n', 'P,S,Cl,K,Ca,Ba,Mn,Br,Rb,Sr,BKGD');
%fprintf(fid, '%s,', c{1,1:end-1}) ;
%fprintf(fid, '%s\n', c{1,end}) ;
%fclose(fid) ;
%dlmwrite('results.csv', c(2:end,:), '-append') ;

