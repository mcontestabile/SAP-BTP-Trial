CLASS zmc_saptutorial_readtable DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_aco_proxy .

    TYPES:
      so_text001                     TYPE c LENGTH 000001 ##TYPSHADOW .
    TYPES:
      boole_d                        TYPE c LENGTH 000001 ##TYPSHADOW .
    TYPES:
      tabname                        TYPE c LENGTH 000030 ##TYPSHADOW .
    TYPES:
      so_int                         TYPE int4 ##TYPSHADOW .
    TYPES:
      BEGIN OF sdti_result                   ,
        line TYPE string,
      END OF sdti_result                    ##TYPSHADOW .
    TYPES:
      sdti_result_tab                TYPE STANDARD TABLE OF sdti_result                    WITH DEFAULT KEY ##TYPSHADOW .
    TYPES:
      sychar512 TYPE c LENGTH 000512 ##TYPSHADOW .
    TYPES:
      BEGIN OF tab512                        ,
        wa TYPE sychar512,
      END OF tab512                         ##TYPSHADOW .
    TYPES:
      _tab512                        TYPE STANDARD TABLE OF tab512                         WITH DEFAULT KEY ##TYPSHADOW .
    TYPES:
      fieldname TYPE c LENGTH 000030 ##TYPSHADOW .
    TYPES:
      doffset TYPE n LENGTH 000006 ##TYPSHADOW .
    TYPES:
      ddleng TYPE n LENGTH 000006 ##TYPSHADOW .
    TYPES:
      inttype TYPE c LENGTH 000001 ##TYPSHADOW .
    TYPES:
      as4text TYPE c LENGTH 000060 ##TYPSHADOW .
    TYPES:
      BEGIN OF rfc_db_fld                    ,
        fieldname TYPE fieldname,
        offset    TYPE doffset,
        length    TYPE ddleng,
        type      TYPE inttype,
        fieldtext TYPE as4text,
      END OF rfc_db_fld                     ##TYPSHADOW .
    TYPES:
      _rfc_db_fld                    TYPE STANDARD TABLE OF rfc_db_fld                     WITH DEFAULT KEY ##TYPSHADOW .
    TYPES:
      so_text TYPE c LENGTH 000072 ##TYPSHADOW .
    TYPES:
      BEGIN OF rfc_db_opt                    ,
        text TYPE so_text,
      END OF rfc_db_opt                     ##TYPSHADOW .
    TYPES:
      _rfc_db_opt                    TYPE STANDARD TABLE OF rfc_db_opt                     WITH DEFAULT KEY ##TYPSHADOW .

    METHODS constructor
      IMPORTING
        !destination TYPE REF TO if_rfc_dest
      RAISING
        cx_rfc_dest_provider_error .
    METHODS rfc_read_table
      IMPORTING
        !delimiter            TYPE so_text001 DEFAULT space
        !get_sorted           TYPE boole_d OPTIONAL
        !no_data              TYPE so_text001 DEFAULT space
        !query_table          TYPE tabname
        !rowcount             TYPE so_int DEFAULT '0'
        !rowskips             TYPE so_int DEFAULT '0'
        !use_et_data_4_return TYPE boole_d OPTIONAL
      EXPORTING
        !et_data              TYPE sdti_result_tab
      CHANGING
        !data                 TYPE _tab512 OPTIONAL
        !fields               TYPE _rfc_db_fld OPTIONAL
        !options              TYPE _rfc_db_opt OPTIONAL
      RAISING
        cx_aco_application_exception
        cx_aco_communication_failure
        cx_aco_system_failure .
  PROTECTED SECTION.

    DATA destination TYPE rfcdest .
  PRIVATE SECTION.
ENDCLASS.



CLASS ZMC_SAPTUTORIAL_READTABLE IMPLEMENTATION.


  METHOD constructor.
    me->destination = destination->get_destination_name( ).
  ENDMETHOD.


  METHOD rfc_read_table.
    DATA: _rfc_message_ TYPE aco_proxy_msg_type.
    CALL FUNCTION 'RFC_READ_TABLE' DESTINATION me->destination
      EXPORTING
        delimiter             = delimiter
        get_sorted            = get_sorted
        no_data               = no_data
        query_table           = query_table
        rowcount              = rowcount
        rowskips              = rowskips
        use_et_data_4_return  = use_et_data_4_return
      IMPORTING
        et_data               = et_data
      TABLES
        data                  = data
        fields                = fields
        options               = options
      EXCEPTIONS
        data_buffer_exceeded  = 1
        field_not_valid       = 2
        not_authorized        = 3
        option_not_valid      = 4
        table_not_available   = 5
        table_without_data    = 6
        communication_failure = 7 MESSAGE _rfc_message_
        system_failure        = 8 MESSAGE _rfc_message_
        OTHERS                = 9.
    IF sy-subrc NE 0.
      DATA __sysubrc TYPE sy-subrc.
      DATA __textid TYPE aco_proxy_textid_type.
      __sysubrc = sy-subrc.
      __textid-msgid = sy-msgid.
      __textid-msgno = sy-msgno.
      __textid-attr1 = sy-msgv1.
      __textid-attr2 = sy-msgv2.
      __textid-attr3 = sy-msgv3.
      __textid-attr4 = sy-msgv4.
      CASE __sysubrc.
        WHEN 1 .
          RAISE EXCEPTION TYPE cx_aco_application_exception
            EXPORTING
              exception_id = 'DATA_BUFFER_EXCEEDED'
              textid       = __textid.
        WHEN 2 .
          RAISE EXCEPTION TYPE cx_aco_application_exception
            EXPORTING
              exception_id = 'FIELD_NOT_VALID'
              textid       = __textid.
        WHEN 3 .
          RAISE EXCEPTION TYPE cx_aco_application_exception
            EXPORTING
              exception_id = 'NOT_AUTHORIZED'
              textid       = __textid.
        WHEN 4 .
          RAISE EXCEPTION TYPE cx_aco_application_exception
            EXPORTING
              exception_id = 'OPTION_NOT_VALID'
              textid       = __textid.
        WHEN 5 .
          RAISE EXCEPTION TYPE cx_aco_application_exception
            EXPORTING
              exception_id = 'TABLE_NOT_AVAILABLE'
              textid       = __textid.
        WHEN 6 .
          RAISE EXCEPTION TYPE cx_aco_application_exception
            EXPORTING
              exception_id = 'TABLE_WITHOUT_DATA'
              textid       = __textid.
        WHEN 7 .
          RAISE EXCEPTION TYPE cx_aco_communication_failure
            EXPORTING
              rfc_msg = _rfc_message_.
        WHEN 8 .
          RAISE EXCEPTION TYPE cx_aco_system_failure
            EXPORTING
              rfc_msg = _rfc_message_.
        WHEN 9 .
          RAISE EXCEPTION TYPE cx_aco_application_exception
            EXPORTING
              exception_id = 'OTHERS'
              textid       = __textid.
      ENDCASE.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
