% This program is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.

% You should have received a copy of the GNU General Public License
% along with this program.  If not, see <https://www.gnu.org/licenses/>.

% This program is Developed by Manuel Flores Qui√±ones

% The ibjective of this code is to get the macronutrients needed in
%  order to stablish a diet or change one.
% The program gets as inputs the Age, Weight (kg), Height (cm), and the
% frequency in which you excercise,
% you can learn more about it in the documentation segment of the git.

% -----KNOWLEDGE BASE-----
%This is the relation of one kilogram to grams of Proteins
kb_grProteins(male, 2.1).
kb_grProteins(female, 2).
%This is the relation of one Kilogram to grams of Fat
kb_grFat(male, 0.9).
kb_grFat(female, 0.9).

kb_grWeight(male, 9.99).
kb_grWeight(female, 9.99).

kb_Height(male, 6.25).
kb_Height(female, 6.25).

kb_Age(male, 4.92).
kb_Age(female, 4.92).

% Relacion Termogenesis de Alimentos (Food thermogenesis)
kb_TA(male, 0.1).
kb_TA(female, 0.1).


% Gasto metabolico basal (Basal metabolic rate)
getGMB(male, GMB, Weight, Height, Age):-
    kb_grWeight(male, X),
    kb_Height(male, Y),
    kb_Age(male, Z),
    GMB is (Weight*X + Height*Y - Age*Z)+5.

getGMB(female, GMB, Weight, Height, Age):-
    kb_grWeight(female, X),
    kb_Height(female, Y),
    kb_Age(female, Z),
    GMB is (Weight*X + Height*Y - Age*Z)-161.

% Actividad Fisica (Phisical Activity)
getAF(Gender, AF, Phisical_Act, GMB, Weight, Height, Age):-
    getGMB(Gender, GMB, Weight, Height, Age),
    AF is GMB*Phisical_Act.

getObjCal(Gender, Objective_Cal, GMB, Weight, Height, Age, Phisical_Act):-
    getGMB(Gender, GMB, Weight, Height, Age),
    getAF(Gender, AF, Phisical_Act, GMB, Weight, Height, Age),
    getTA(Gender, TA, GMB, Weight, Height, Age),
    Objective_Cal is GMB+TA+AF-500.

% C·lculo Termogenesis de Alimentos (Calculates Food thermogenesis)
getTA(Gender, TA, GMB, Weight, Height, Age):-
    getGMB(Gender, GMB, Weight, Height, Age),
    kb_TA(Gender, X),
    TA is GMB*X.

grProteins(Gender, GrProt, Weight):-
	kb_grProteins(Gender, X),
	GrProt is Weight*X.

grFat(Gender, GrFat, Weight):-
	kb_grFat(Gender, X),
	GrFat is Weight*X.

grCarbohydrates(Gender, Weight, KiloCal_Proteins, KiloCal_Fat, Objective_Cal, KiloCal_Carbohydrates, GrCarbohydrates):-
    kcalCh(Gender, KiloCal_Proteins, KiloCal_Fat, Objective_Cal, KiloCal_Carbohydrates, Weight),
    GrCarbohydrates is KiloCal_Carbohydrates/4.

kcalProteina(Gender, Weight, KiloCal_Proteins):-
    grProteins(Gender, GrProt, Weight),
    KiloCal_Proteins is GrProt*4.

kcalFat(Gender, Weight, KiloCal_Fat):-
    grFat(Gender, GrFat, Weight),
    KiloCal_Fat is GrFat*9.

kcalCh(Gender, KiloCal_Proteins, KiloCal_Fat, Objective_Cal, KiloCal_Carbohydrates, Weight):-
    kcalProteina(Gender, Weight, KiloCal_Proteins),
    kcalFat(Gender, Weight, KiloCal_Fat),
    KiloCal_Carbohydrates is Objective_Cal-KiloCal_Proteins-KiloCal_Fat.

getMacros(Gender, Weight, Height, Age, Phisical_Act, GrProteins, GrFat, GrCarbohydrates):-
	getGMB(Gender, GMB, Weight, Height, Age),
	getObjCal(Gender, Objective_Cal, GMB, Weight, Height, Age, Phisical_Act),
        grProteins(Gender, GrProteins, Weight),
        grFat(Gender, GrFat, Weight),
        kcalCh(Gender, Kilo_Proteins, Kilo_Fat, Objective_Cal, Kilo_Carbo, Weight),
        grCarbohydrates(Gender, Weight, Kilo_Proteins, Kilo_Fat, Objective_Cal, Kilo_Carbo, GrCarbohydrates).








