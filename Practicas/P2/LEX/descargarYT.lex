ID				[0-9a-zA-Z\-_]{11}
VIDEO_ID			\"video_id\":\"{ID}\"
TITLE				\"title\":\"[^\"]+\"
AUTHOR				\"author\":\"[0-9a-zA-Zá-Á-Ú\-_" "]+\"
URL_ENCODED_FTM_STREAM_MAP	\"url_encoded_fmt_stream_map\":\"([^"url="]+)?url=https[^\"]+\"
VIEW_COUNT			\"view_count\":\"[0-9]+\"
LENGTH_SECONDS			\"length_seconds\":\"[0-9]+\"
TAG_FOR_CHILD_DIRECTED		\"tag_for_child_directed\":("true"|"false")

AUTHOR_REF			\"ucid\":\"[0-9a-zA-Z\-_]{24}\"

SUFIX				"\\/default\.jpg"\"
PREFIX				\"thumbnail_url\":\""https:\\/\\/i\.ytimg\.com\\/vi\\/"
THUMBNAIL_URL			{PREFIX}{ID}{SUFIX}

LIKE				"<button class="\""yt-uix-button yt-uix-button-size-default yt-uix-button-opacity yt-uix-button-has-icon no-icon-markup like-button-renderer-like-button like-button-renderer-like-button-clicked yt-uix-button-toggled  hid yt-uix-tooltip"\"" "type=\"button\"" "onclick=\"";return false;"\"" "title=\"[^\"]+\"" aria-label"=\"[^1-9]+{NUMBERPOINT}[^\"]+\"" data-position"=\"bottomright\"" data-orientation"=\"vertical\"" data-force-position"=\"true\""><span class"=\""yt-uix-button-content"\"">"{NUMBERPOINT}"</span>"

DISLIKE				"<button class="\""yt-uix-button yt-uix-button-size-default yt-uix-button-opacity yt-uix-button-has-icon no-icon-markup like-button-renderer-dislike-button like-button-renderer-dislike-button-clicked yt-uix-button-toggled  hid yt-uix-tooltip"\"" "type=\"button\"" "onclick=\"";return false;"\"" "title=\"[^\"]+\"" aria-label"=\"[^1-9]+{NUMBERPOINT}[^\"]+\"" data-position"=\"bottomright\"" data-orientation"=\"vertical\"" data-force-position"=\"true\""><span class"=\""yt-uix-button-content"\"">"{NUMBERPOINT}"</span>"
				

SUBS				.longSubscriberCountText.+

NUMBERPOINT			[1-9]{1,3}("."[0-9]{3})*

NONE				.|\n

%{
	#include<unistd.h>
	#include<stdio.h>
	#include<sys/types.h>
	#include <sys/wait.h>
	#include<stdlib.h>
	#include<errno.h>

	pid_t PID;
	int estado;
	char *cadenaTitle, *cadenaVideoID, *cadenaAuthor, *cadenaViewCount, *cadenaLenght, *cadenaChild, *cadenaAuthorRef, *cadenaThumbnail, *cadenaLike, *cadenaDislike;
	int longitud_numero;
	const int SIZE_THUMBNAIL = 46;
	const char* OFFSET_THUMBNAIL = "\"thumbnail_url\":\"";
	const char* OFFSET_VIEW_COUNT = "\"view_count\":\"";
	const char* OFFSET_LENGTH_SECONDS = "\"length_seconds\":\"";
	const char* OFFSET_TAG_FOR_CHILD_DIRECTED = "\"tag_for_child_directed\":";
	const char* OFFSET_AUTHOR_REF = "\"ucid\":\"";
	const char* OFFSET_VIDEO_ID = "\"video_id\":\"";
	const char* OFFSET_TITLE = "\"title\":\"";
	const char* OFFSET_AUTHOR = "\"author\":\"";

	void substring(char *src, char *dest, const char *first, const char last){
		int idx = 0;

		for(int i = strlen(first); yytext[i] != last; ++i)
			dest[idx++] = src[i];
	}

	void substringReverse(char *src, char *dest, const char *first, const char last){
		int idx = 0;
		char aux;

		for(int i = strlen(src)-strlen(first) - 1; yytext[i] != last; --i)
			dest[idx++] = src[i];

		dest[idx] = '\0';

		for(int i = 0; i < idx/2; ++i) {
			aux = dest[i];
			dest[i] = dest[strlen(dest) - i];
			dest[strlen(dest) - i] = aux;
		}

		
	}
	


%}

%%
{URL_ENCODED_FTM_STREAM_MAP} 	{/*printf("url: %s\n",yytext);*/}
{TITLE}				{
	cadenaTitle = (char*) malloc(sizeof(char) * (strlen(yytext) - strlen(OFFSET_TITLE)));
	substring(yytext, cadenaTitle, OFFSET_TITLE, '"');

	//printf("Titulo: %s\n",cadenaTitle);
	//free(cadenaTitle);
}

{VIDEO_ID} 			{
	cadenaVideoID = (char*) malloc(sizeof(char) * (strlen(yytext) - strlen(OFFSET_VIDEO_ID)));
	substring(yytext, cadenaVideoID, OFFSET_VIDEO_ID, '"');

	//printf("Video ID: %s\n",cadenaVideoID);
	//free(cadenaVideoID);
}

{AUTHOR} 			{
	cadenaAuthor = (char*) malloc(sizeof(char) * (strlen(yytext) - strlen(OFFSET_AUTHOR)));
	substring(yytext, cadenaAuthor, OFFSET_AUTHOR, '"');

	//printf("Autor: %s\n",cadenaAuthor);
	//free(cadenaAuthor);	
}

{VIEW_COUNT} 			{
	cadenaViewCount = (char*) malloc(sizeof(char) * (strlen(yytext) - strlen(OFFSET_VIEW_COUNT)));
	substring(yytext, cadenaViewCount, OFFSET_VIEW_COUNT, '"');
	//printf("Visitas: %s\n",cadenaViewCount);
	//free(cadenaViewCount);
}
{LENGTH_SECONDS} 		{
	cadenaLenght = (char*) malloc(sizeof(char) * (strlen(yytext) - strlen(OFFSET_LENGTH_SECONDS)));
	substring(yytext, cadenaLenght, OFFSET_LENGTH_SECONDS, '"');

	//printf("Duracion: %s\n",cadenaLenght);
	//free(cadenaLenght);
}

{TAG_FOR_CHILD_DIRECTED}	{
	cadenaChild = (char*) malloc(sizeof(char) * (strlen(yytext) - strlen(OFFSET_TAG_FOR_CHILD_DIRECTED)));
	substring(yytext, cadenaChild, OFFSET_TAG_FOR_CHILD_DIRECTED, '\0');

	//printf("Apto para menores: %s\n",cadenaChild);
	//free(cadenaChild);
}

{AUTHOR_REF}			{
	cadenaAuthorRef = (char*) malloc(sizeof(char) * (strlen(yytext) - strlen(OFFSET_AUTHOR_REF)));
	substring(yytext, cadenaAuthorRef, OFFSET_AUTHOR_REF, '"');

	//printf("Referencia Autor: %s\n",cadenaAuthorRef);
	//free(cadenaAuthorRef);
}

{THUMBNAIL_URL}			{
	cadenaThumbnail = (char*) malloc(sizeof(char) * (strlen(yytext) - strlen(OFFSET_THUMBNAIL)));
	int idx = 0;

	for(int i = strlen(OFFSET_THUMBNAIL); yytext[i] != '\0'; ++i)
		if(yytext[i] != '\\')
			cadenaThumbnail[idx++] =  yytext[i];

	cadenaThumbnail[idx-1] = NULL;


	printf("Miniatura: %s\n", cadenaThumbnail);

	if((PID = fork()) < 0) {
		perror("fork");
		exit(EXIT_FAILURE);
	}

	if(PID == 0) {
		execl("/usr/bin/wget","/usr/bin/wget","--output-document=miniatura.jpg",cadenaThumbnail,"-o log_thumbnail.log",NULL);
	}

}
{LIKE}				{
	cadenaLike = (char*) malloc(sizeof(char) * longitud_numero);
	substringReverse(yytext, cadenaLike, "</span>", '>');

	//printf("Like: %s\n",cadenaLike);
	//free(cadenaLike);
}
{DISLIKE}			{
	cadenaDislike = (char*) malloc(sizeof(char) * longitud_numero);
	substringReverse(yytext, cadenaDislike, "</span>", '>');

	//printf("Dislike: %s\n",cadenaDislike);
	//free(cadenaDislike);
}

{NUMBERPOINT}			{longitud_numero = strlen(yytext);}
{NONE}				{}

%%

int main(int argc, char *argv[]) {



	if(argc != 2) {
		printf("Uso: %s <url>\n", argv[0]);
		exit(EXIT_FAILURE);
	}

	if((PID = fork()) < 0) {
		perror("fork");
		exit(EXIT_FAILURE);
	}

	if(PID == 0) {
		execl("/usr/bin/wget","/usr/bin/wget","--output-document=video.html","-ck",argv[1],"-o log_main.log",NULL);
	}

	else{

		wait(&estado);
		yyin = fopen ("video.html", "r");

		yylex();

		fclose(yyin);

		printf("Titulo: %s\n",cadenaTitle);
		printf("Video ID: %s\n",cadenaVideoID);
		printf("Autor: %s\n",cadenaAuthor);
		printf("Visitas: %s\n",cadenaViewCount);
		printf("Duracion: %s\n",cadenaLenght);
		printf("Apto para menores: %s\n",cadenaChild);
		printf("Like: %s\n",cadenaLike);
		printf("Dislike: %s\n",cadenaDislike);
		free(cadenaDislike);
		free(cadenaLike);
		free(cadenaChild);
		free(cadenaLenght);
		free(cadenaViewCount);
		free(cadenaAuthor);
		free(cadenaVideoID);
		free(cadenaTitle);
		free(cadenaThumbnail);

		remove("video.html");
	}
}
