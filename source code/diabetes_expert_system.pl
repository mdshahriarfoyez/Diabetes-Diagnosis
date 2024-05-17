:- dynamic patient/9.
:- dynamic diagnostic_test/4.
:- dynamic symptom/2.
:- dynamic diagnostic_criteria/3.

% Initialization
:- initialization(start, main).

% Entry point
start :-
    write('Welcome to the Diabetes Diagnosis Expert System.\n'),
    write('Please enter patient details.\n'),
    read_patient_info.

% Read patient information
read_patient_info :-
    write('Enter patient ID: '),
    read(PatientID),
    write('Enter patient age: '),
    read(Age),
    write('Enter patient gender (male/female): '),
    read(Gender),
    write('Enter patient weight (kg): '),
    read(Weight),
    write('Enter patient height (cm): '),
    read(Height),
    write('Enter patient fasting blood sugar level (mg/dL): '),
    read(FastingBS),
    write('Enter patient random blood sugar level (mg/dL): '),
    read(RandomBS),
    write('Enter patient OGTT blood sugar level (mg/dL): '),
    read(OGTT_BS),
    write('Enter patient HbA1c level: '),
    read(HbA1c),
    write('Enter patient symptoms (comma-separated, end with a period): '),
    read(Symptoms),
    assert_patient(PatientID, Age, Gender, Weight, Height, FastingBS, RandomBS, OGTT_BS, HbA1c),
    assert_symptoms(PatientID, Symptoms),
    diagnose_diabetes(PatientID).

% Assert patient information
assert_patient(ID, Age, Gender, Weight, Height, FastingBS, RandomBS, OGTT_BS, HbA1c) :-
    assertz(patient(ID, Age, Gender, Weight, Height, FastingBS, RandomBS, OGTT_BS, HbA1c)).

% Assert patient symptoms
assert_symptoms(_, []) :- !.
assert_symptoms(PatientID, [Symptom|Symptoms]) :-
    assertz(symptom(PatientID, Symptom)),
    assert_symptoms(PatientID, Symptoms).

% Define diagnostic test results
diagnostic_criteria(fasting_blood_sugar, 126, 'mg/dL').
diagnostic_criteria(random_blood_sugar, 200, 'mg/dL').
diagnostic_criteria(ogtt_blood_sugar, 200, 'mg/dL').
diagnostic_criteria(hba1c_level, 6.5, '').

% Define the main predicate for diagnosis
diagnose_diabetes(PatientID) :-
    patient(PatientID, Age, _, _, _, FastingBS, RandomBS, OGTT_BS, HbA1c),
    write('Patient Information:\n'),
    write('ID: '), write(PatientID), nl,
    write('Age: '), write(Age), nl,
    write('Fasting Blood Sugar: '), write(FastingBS), write(' mg/dL'), nl,
    write('Random Blood Sugar: '), write(RandomBS), write(' mg/dL'), nl,
    write('OGTT Blood Sugar: '), write(OGTT_BS), write(' mg/dL'), nl,
    write('HbA1c Level: '), write(HbA1c), nl,
    evaluate_diagnostic_tests(PatientID).

% Evaluate diagnostic tests
evaluate_diagnostic_tests(PatientID) :-
    patient(PatientID, _, _, _, _, FastingBS, RandomBS, OGTT_BS, HbA1c),
    (   FastingBS >= 126 ;
        RandomBS >= 200 ;
        OGTT_BS >= 200 ;
        HbA1c >= 6.5 ),
    write('Diagnosis: Diabetes mellitus confirmed.\n'),
    retract_patient(PatientID).

evaluate_diagnostic_tests(_PatientID) :-
    write('Diagnosis: No diabetes mellitus detected.\n').

% Retract patient information
retract_patient(PatientID) :-
    retract(patient(PatientID, _, _, _, _, _, _, _, _)),
    retractall(symptom(PatientID, _)).
