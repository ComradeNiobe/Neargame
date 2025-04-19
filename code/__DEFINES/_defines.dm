// Define o macro da IZ.
#define INTERZONE "IZ"
// Define o macro da BRZ.
#define BRZONE "BR"

// TODO: Escrever um script para modificar isso em runtime.
#define CURRENT_LANG BRZONE

// Define o macro SRVR_LANG
#define SRVR_LANG server_language
// Checa se a VARIÁVEL server_language é BRzone.
#define CHCKV_BRZ SRVR_LANG == BRZONE
// Checa se a VARIÁVEL server_language é Interzone.
#define CHCKV_IZ SRVR_LANG == INTERZONE
// Checa se o MACRO CURRENT_LANG é Interzone.
#define CHECKM_IZ CURRENT_LANG == INTERZONE
// Checa se o MACRO CURRENT_LANG é BRzone.
#define CHECKM_BRZ CURRENT_LANG == BRZONE

// Troca a VARIÁVEL server_language para o idioma especificado.
#define SET_LANG(X) SRVR_LANG = X

// Define o macro que lista a porta da BRzone.
#define BRZ_PORT 1984
// Define o macro que lista a porta da Interzone (S2).
#define IZ2_PORT 2422
// Define o macro que lista a porta da Interzone (S1).
#define IZ1_PORT 1923
// Festa privada.
#define SHROOM_PORT 1969
// Define o macro que lista a porta do servidor de testes (S3).
#define IZ3_PORT 9530

// Quantidade máxima de pessoas que um comrade pode convidar.
#define MAX_COMRADE_INVITES 14

#define ceil(x) (-round(-(x)))

#define EGG_DELAY 5 MINUTES
#define SPIT_DELAY 16 SECONDS
#define WEED_DELAY 60 SECONDS

#define MAX_SAVE_SLOTS 15