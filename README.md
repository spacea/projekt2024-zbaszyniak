# DAYSEEK
Aplikacja, którą stworzyłyśmy służy do sprawdzenia, kto ze znanych ludzi urodził się w dany, wybrany przez użytkownika dzień. Dzięki niej możesz sprawdzić kto jest twoim "sławnym bliźniakiem", a także trochę się o nim dowiedzieć. Aby wyświetlić listę osób, wybierz datę z panelu po lewej stronie a następnie zapoznaj się z informacjami na stronie.  <br> <br> 
Warto także zajrzeć do zakładki "QUICK LOOK INTO DATASET" gdzie możesz dowiedzieć się więcej o danych, które wykorzystałyśmy przy tworzeniu aplikacji. 
# Jak uruchomić nasz projekt?
## Bez pobierania repozytorium 
Wklej kod w dowolnym skrypcie R w odpowiednim IDE np. R Studio i uruchom go poprzez przejście przez każdą linijkę skrótem Ctrl + Enter. 
```
library(shiny)
runGitHub("projekt2024-zbaszyniak", "spacea")
```
## Pobieranie repozytorium
- Pobierz projekt: Przejdź do repozytorium projektu na GitHubie i sklonuj repozytorium na swój komputer, używając opcji "Clone" lub pobierając je jako archiwum ZIP.

- Instalacja: upewnij się, że masz zainstalowane wszystkie zależności i narzędzia wymagane do uruchomienia projektu takie jak R i R Studio

- Otwórz R Studio: uruchom aplikację R Studio na swoim komputerze.

- Utwórz nowy projekt: w menu R Studio wybierz opcję "File" (Plik), a następnie "New Project" (Nowy Projekt).

- Wybierz Katalog: Wybierz opcję "Existing Directory" (Istniejący Katalog) i przejdź do katalogu, w którym znajduje się skopiowane repozytorium projektu.

- Otwórz projekt: kliknij przycisk "Create Project" (Utwórz Projekt), aby otworzyć projekt w R Studio.

- Przeglądaj pliki projektu: Po otwarciu projektu w R Studio, możesz przeglądać wszystkie pliki i foldery związane z naszym projektem. Otwórz plik app.R.

- Uruchom skrypt: aplikację możesz uruchomić bezpośrednio w R Studio, klikając przycisk "Run" (Uruchom) lub używając skrótów klawiaturowych. Należy przejść przez wszystkie elementy kodu klikając Ctrl + Enter.

# Niezbędne pakiety
Do pierwszego uruchomienia aplikacji potrzebować będzie potrzebne zainstalowanie odpowiednich pakietów, bez których aplikacja nie będzie działać. Instalacja potrzebna jest tylko przed pierwszym uruchomieniem, jeśli wcześniej nie instalowaliśmy takich pakietów. Można je zainstalować z użyciem poniższego kodu. Aby wykonać kod, wklej go w dowolnym skrypcie R i wykonaj każdą linijkę z użyciem Ctrl + Enter. 
```R
  install.package ("shiny")
  install.package ("semantic.dashboard")
  install.package ("plotly")
  install.package ("DT")
```

# Zawartość repozytorium
- databaseprep.R - plik dokumnetujący w jaki sposób przygotowałyśmy dane
- app.R - właściwy plik aplikacji
- dane_projekt3.csv i databasemap.csv - bazy danych używane w aplikacji
- .gitignore, .rProj to rozszerzenia plików używanych do konfiguracji projektu i kontroli wersji
# Źródła danych

- dane pobrane ze strony https://www.kaggle.com/datasets/arwind25/40-birthdays-of-famous-people-for-every-date?resource=download
- dane pobrane ze strony https://data.sciencespo.fr/dataset.xhtml?persistentId=doi:10.21410/7E4/RDAG3O 
- artykuł oraz metadane: https://www.nature.com/articles/s41597-022-01369-4#code-availability 


# Autorzy (a bardziej autorki)

- Maria Zbąszyniak
- Maria Kaźmierska 
