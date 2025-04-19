//Error handler defines
#define ERROR_USEFUL_LEN 2

#define TYPE_IS_ABSTRACT(D) (initial(D.abstract_type) == D)
#define TYPE_IS_SPAWNABLE(D) (!TYPE_IS_ABSTRACT(D) && initial(D.is_spawnable_type))
#define INSTANCE_IS_ABSTRACT(D) (D.abstract_type == D.type)

#define EXCEPTION_TEXT(E) "'[E.name]' ('[E.type]'): '[E.file]':[E.line]:\n'[E.desc]'"
