//
// Created by anas elgarhy on 11/19/22.
//
#ifndef DMENU_H
#define DMENU_H


/* macros */
#define INTERSECT(x, y, w, h, r)  (MAX(0, MIN((x)+(w),(r).x_org+(r).width)  - MAX((x),(r).x_org)) \
                             * MAX(0, MIN((y)+(h),(r).y_org+(r).height) - MAX((y),(r).y_org)))
#define LENGTH(X)             (sizeof X / sizeof X[0])
#define TEXTW(X)              (drw_fontset_getwidth(drw, (X)) + lrpad)

/* enums */
enum {
    SchemeNorm, SchemeSel, SchemeOut, SchemeNormHighlight, SchemeSelHighlight, SchemeOutHighlight, SchemeLast
}; /* color schemes */
struct item {
    char *text;
    struct item *left, *right;
    int out;
};

static char text[BUFSIZ] = "";
static char fribidi_text[BUFSIZ] = "";
static char *embed;
static int bh, mw, mh;
static int inputw = 0, promptw;
static int lrpad; /* sum of left and right padding */
static size_t cursor;
static struct item *items = NULL;
static struct item *matches, *matchend;
static struct item *prev, *curr, *next, *sel;
static int mon = -1, screen;

static Atom clip, utf8;
static Display *dpy;
static Window root, parentwin, win;
static XIC xic;

static Drw *drw;
static Clr *scheme[SchemeLast];


static char* cistrstr(const char *s, const char *sub);

static int (*fstrncmp)(const char *, const char *, size_t) = strncasecmp;

static char* (*fstrstr)(const char *, const char *) = cistrstr;

void drawhighlights(struct item *item, int x, int y, int maxw);
void applay_fribidi(char *text);

#endif //DMENU_H
