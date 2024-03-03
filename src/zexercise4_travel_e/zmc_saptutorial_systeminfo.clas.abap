CLASS zmc_saptutorial_systeminfo DEFINITION
  PUBLIC
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_aco_proxy .

    TYPES:
      syst_index                     TYPE int4 ##TYPSHADOW .
    TYPES:
      rfcproto TYPE c LENGTH 000003 ##TYPSHADOW .
    TYPES:
      rfcchartyp TYPE c LENGTH 000004 ##TYPSHADOW .
    TYPES:
      rfcinttyp TYPE c LENGTH 000003 ##TYPSHADOW .
    TYPES:
      rfcflotyp TYPE c LENGTH 000003 ##TYPSHADOW .
    TYPES:
      rfcdest TYPE c LENGTH 000032 ##TYPSHADOW .
    TYPES:
      rfcchar8 TYPE c LENGTH 000008 ##TYPSHADOW .
    TYPES:
      sysysid TYPE c LENGTH 000008 ##TYPSHADOW .
    TYPES:
      rfcdbhost TYPE c LENGTH 000032 ##TYPSHADOW .
    TYPES:
      sydbsys TYPE c LENGTH 000010 ##TYPSHADOW .
    TYPES:
      sysaprl TYPE c LENGTH 000004 ##TYPSHADOW .
    TYPES:
      rfcmach TYPE c LENGTH 000005 ##TYPSHADOW .
    TYPES:
      syopsys TYPE c LENGTH 000010 ##TYPSHADOW .
    TYPES:
      rfctzone TYPE c LENGTH 000006 ##TYPSHADOW .
    TYPES:
      sydayst TYPE c LENGTH 000001 ##TYPSHADOW .
    TYPES:
      rfcipaddr TYPE c LENGTH 000015 ##TYPSHADOW .
    TYPES:
      sykernrl TYPE c LENGTH 000004 ##TYPSHADOW .
    TYPES:
      syhost TYPE c LENGTH 000032 ##TYPSHADOW .
    TYPES:
      rfcsi_resv TYPE c LENGTH 000012 ##TYPSHADOW .
    TYPES:
      rfcipv6addr TYPE c LENGTH 000045 ##TYPSHADOW .
    TYPES:
      BEGIN OF rfcsi                         ,
        rfcproto    TYPE rfcproto,
        rfcchartyp  TYPE rfcchartyp,
        rfcinttyp   TYPE rfcinttyp,
        rfcflotyp   TYPE rfcflotyp,
        rfcdest     TYPE rfcdest,
        rfchost     TYPE rfcchar8,
        rfcsysid    TYPE sysysid,
        rfcdatabs   TYPE sysysid,
        rfcdbhost   TYPE rfcdbhost,
        rfcdbsys    TYPE sydbsys,
        rfcsaprl    TYPE sysaprl,
        rfcmach     TYPE rfcmach,
        rfcopsys    TYPE syopsys,
        rfctzone    TYPE rfctzone,
        rfcdayst    TYPE sydayst,
        rfcipaddr   TYPE rfcipaddr,
        rfckernrl   TYPE sykernrl,
        rfchost2    TYPE syhost,
        rfcsi_resv  TYPE rfcsi_resv,
        rfcipv6addr TYPE rfcipv6addr,
      END OF rfcsi                          ##TYPSHADOW .
    TYPES:
      char1                          TYPE c LENGTH 000001 ##TYPSHADOW .

    METHODS constructor
      IMPORTING
        !destination TYPE REF TO if_rfc_dest
      RAISING
        cx_rfc_dest_provider_error .
    METHODS rfc_system_info
      EXPORTING
        !current_resources TYPE syst_index
        !fast_ser_vers     TYPE int4
        !fqhn              TYPE string
        !maximal_resources TYPE syst_index
        !recommended_delay TYPE syst_index
        !rfcsi_export      TYPE rfcsi
        !s4_hana           TYPE char1
      RAISING
        cx_aco_application_exception
        cx_aco_communication_failure
        cx_aco_system_failure .
  PROTECTED SECTION.

    DATA destination TYPE rfcdest .
  PRIVATE SECTION.
ENDCLASS.



CLASS ZMC_SAPTUTORIAL_SYSTEMINFO IMPLEMENTATION.


  METHOD constructor.
    me->destination = destination->get_destination_name( ).
  ENDMETHOD.


  METHOD rfc_system_info.
    DATA: _rfc_message_ TYPE aco_proxy_msg_type.
    CALL FUNCTION 'RFC_SYSTEM_INFO' DESTINATION me->destination
      IMPORTING
        current_resources     = current_resources
        fast_ser_vers         = fast_ser_vers
        fqhn                  = fqhn
        maximal_resources     = maximal_resources
        recommended_delay     = recommended_delay
        rfcsi_export          = rfcsi_export
        s4_hana               = s4_hana
      EXCEPTIONS
        communication_failure = 1 MESSAGE _rfc_message_
        system_failure        = 2 MESSAGE _rfc_message_
        OTHERS                = 3.
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
          RAISE EXCEPTION TYPE cx_aco_communication_failure
            EXPORTING
              rfc_msg = _rfc_message_.
        WHEN 2 .
          RAISE EXCEPTION TYPE cx_aco_system_failure
            EXPORTING
              rfc_msg = _rfc_message_.
        WHEN 3 .
          RAISE EXCEPTION TYPE cx_aco_application_exception
            EXPORTING
              exception_id = 'OTHERS'
              textid       = __textid.
      ENDCASE.
    ENDIF.

  ENDMETHOD.
ENDCLASS.
