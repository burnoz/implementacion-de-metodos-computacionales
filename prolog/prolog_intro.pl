% Gatos
species(ada, cat).
species(lily, cat).
species(gus, cat).

% Perros
species(fido, dog).
species(lara, dog).
species(octy, dog).

genderOf(male, gus).
genderOf(male, octy).
genderOf(male, gus).
genderOf(female, ada).
genderOf(female, lily).
genderOf(female, lara).

breed(fido, chihuahua).
breed(lara, doberman).
breed(octy, pomeriano).

% Humanos
human(ana).
human(carlos).

size(big, X) :- breed(X, doberman).
% ; es un or
size(small, X) :- breed(X, pomeriano) ; breed(X, chihuahua) ; species(X, cat).

pet(X) :- species(X, cat) ; species(X, dog).

% Reglas
% , es un and
likes(ana, X) :- genderOf(female, X) , species(X, cat).
likes(carlos, X) :- species(X, dog) , size(small, X).

canHave(A, B) :- human(A) , pet(B) , likes(A, B).


