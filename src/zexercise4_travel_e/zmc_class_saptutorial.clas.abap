CLASS zmc_class_saptutorial DEFINITION
  PUBLIC
  FINAL
  CREATE PUBLIC .

  PUBLIC SECTION.

    INTERFACES if_oo_adt_classrun .
  PROTECTED SECTION.
  PRIVATE SECTION.
ENDCLASS.



CLASS ZMC_CLASS_SAPTUTORIAL IMPLEMENTATION.


  METHOD if_oo_adt_classrun~main.
    DATA dest TYPE REF TO if_rfc_dest.
    DATA myobj  TYPE REF TO zmc_saptutorial_systeminfo.

    DATA current_resources TYPE zmc_saptutorial_systeminfo=>syst_index.
    DATA fast_ser_vers TYPE int4.
    DATA fqhn TYPE string.
    DATA maximal_resources TYPE zmc_saptutorial_systeminfo=>syst_index.
    DATA recommended_delay TYPE zmc_saptutorial_systeminfo=>syst_index.
    DATA rfcsi_export TYPE zmc_saptutorial_systeminfo=>rfcsi.
    DATA s4_hana TYPE zmc_saptutorial_systeminfo=>char1.

    TRY.
        dest = cl_rfc_destination_provider=>create_by_cloud_destination( i_name = 'BDT' ).

        CREATE OBJECT myobj
          EXPORTING
            destination = dest.

        myobj->rfc_system_info(
           IMPORTING
             current_resources = current_resources
             fast_ser_vers = fast_ser_vers
             fqhn = fqhn
             maximal_resources = maximal_resources
             recommended_delay = recommended_delay
             rfcsi_export = rfcsi_export
             s4_hana = s4_hana
         ).
      CATCH  cx_aco_communication_failure INTO DATA(lcx_comm).
        " handle CX_ACO_COMMUNICATION_FAILURE (sy-msg* in lcx_comm->IF_T100_MESSAGE~T100KEY)
      CATCH cx_aco_system_failure INTO DATA(lcx_sys).
        " handle CX_ACO_SYSTEM_FAILURE (sy-msg* in lcx_sys->IF_T100_MESSAGE~T100KEY)
      CATCH cx_aco_application_exception INTO DATA(lcx_appl).
        " handle APPLICATION_EXCEPTIONS (sy-msg* in lcx_appl->IF_T100_MESSAGE~T100KEY)
      CATCH cx_rfc_dest_provider_error.
        " handle CX_RFC_DEST_PROVIDER_ERROR
    ENDTRY.

    out->write( |{ current_resources }, { fast_ser_vers }, { maximal_resources }, { recommended_delay }, { rfcsi_export-rfcchartyp }, { s4_hana }| ).
    out->write(  rfcsi_export ).
  ENDMETHOD.
ENDCLASS.
