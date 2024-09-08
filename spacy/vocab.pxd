from cymem.cymem cimport Pool
from libcpp.vector cimport vector
from murmurhash.mrmr cimport hash64
from preshed.maps cimport PreshMap

from .morphology cimport Morphology
from .strings cimport StringStore
from .structs cimport LexemeC, TokenC
from .typedefs cimport attr_t, hash_t


cdef LexemeC EMPTY_LEXEME


cdef union LexemesOrTokens:
    const LexemeC* const* lexemes
    const TokenC* tokens


cdef struct _Cached:
    LexemesOrTokens data
    bint is_lex
    int length


cdef class Vocab:
    cdef Pool mem
    cdef readonly StringStore strings
    cdef public Morphology morphology
    cdef public object _vectors
    cdef public object _lookups
    cdef public object writing_system
    cdef public object get_noun_chunks
    cdef readonly int length
    cdef public object lex_attr_getters
    cdef public object cfg

    cdef const LexemeC* get(self, str string) except NULL
    cdef const LexemeC* get_by_orth(self, attr_t orth) except NULL
    cdef const TokenC* make_fused_token(self, substrings) except NULL

    cdef const LexemeC* _new_lexeme(self, str string) except NULL
    cdef int _add_lex_to_vocab(self, hash_t key, const LexemeC* lex, bint is_transient) except -1

    cdef PreshMap _by_orth
    cdef Pool _non_temp_mem
    cdef vector[attr_t] _transient_orths
