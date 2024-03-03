CLASS zmc_class_saptutorial2 DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZMC_CLASS_SAPTUTORIAL2 IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    DATA dest TYPE REF TO if_rfc_dest.
    DATA myobj  TYPE REF TO zmc_saptutorial_readtable.

    DATA delimiter TYPE zmc_saptutorial_readtable=>so_text001.
    DATA get_sorted TYPE zmc_saptutorial_readtable=>boole_d.
    DATA no_data TYPE zmc_saptutorial_readtable=>so_text001.
    DATA query_table TYPE zmc_saptutorial_readtable=>tabname.
    DATA rowcount TYPE zmc_saptutorial_readtable=>so_int.
    DATA rowskips TYPE zmc_saptutorial_readtable=>so_int.
    DATA use_et_data_4_return TYPE zmc_saptutorial_readtable=>boole_d.
    DATA et_data TYPE zmc_saptutorial_readtable=>sdti_result_tab.
    DATA data TYPE zmc_saptutorial_readtable=>_tab512.
    DATA fields TYPE zmc_saptutorial_readtable=>_rfc_db_fld.
    DATA options TYPE zmc_saptutorial_readtable=>_rfc_db_opt.
    DATA lv_dest TYPE rfcdest VALUE 'BD3CLNT301'.

    TRY.
        lo_dest = .
        CREATE OBJECT myobj
          EXPORTING
            destination = dest.

        query_table = 'SFLIGHT'.
        myobj->rfc_read_table(
           EXPORTING
             delimiter = delimiter
             get_sorted = get_sorted
             no_data = no_data
             query_table = query_table
             rowcount = rowcount
             rowskips = rowskips
             use_et_data_4_return = use_et_data_4_return
           IMPORTING
             et_data = et_data
           CHANGING
             data = data
             fields = fields
             options = options
         ).

        LOOP AT data INTO DATA(ls_wa).
          out->write( ls_wa-wa ).
        ENDLOOP.

      CATCH  cx_aco_communication_failure INTO DATA(lcx_comm).
        " handle CX_ACO_COMMUNICATION_FAILURE (sy-msg* in lcx_comm->IF_T100_MESSAGE~T100KEY)
      CATCH cx_aco_system_failure INTO DATA(lcx_sys).
        " handle CX_ACO_SYSTEM_FAILURE (sy-msg* in lcx_sys->IF_T100_MESSAGE~T100KEY)
      CATCH cx_aco_application_exception INTO DATA(lcx_appl).
        " handle APPLICATION_EXCEPTIONS (sy-msg* in lcx_appl->IF_T100_MESSAGE~T100KEY)
        CASE lcx_appl->get_exception_id( ).
          WHEN 'DATA_BUFFER_EXCEEDED'.
            "handle DATA_BUFFER_EXCEEDED.
          WHEN 'FIELD_NOT_VALID'.
            "handle FIELD_NOT_VALID.
          WHEN 'NOT_AUTHORIZED'.
            "handle NOT_AUTHORIZED.
          WHEN 'OPTION_NOT_VALID'.
            "handle OPTION_NOT_VALID.
          WHEN 'TABLE_NOT_AVAILABLE'.
            "handle TABLE_NOT_AVAILABLE.
          WHEN 'TABLE_WITHOUT_DATA'.
            "handle TABLE_WITHOUT_DATA.
        ENDCASE.
      CATCH cx_rfc_dest_provider_error.
        " handle CX_RFC_DEST_PROVIDER_ERROR
    ENDTRY.

  ENDMETHOD.
ENDCLASS.
