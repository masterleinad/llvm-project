! This test checks lowering of OpenACC declare directive.

! RUN: bbc -fopenacc -emit-fir %s -o - | FileCheck %s

module acc_declare_test
 integer, parameter :: n = 100000
 real, dimension(n) :: data1, data2
 !$acc declare create(data1) create(zero: data2)
end module

! CHECK-LABEL: fir.global @_QMacc_declare_testEdata1 {acc.declare = #acc.declare<dataClause = acc_create>} : !fir.array<100000xf32>

! CHECK-LABEL: acc.global_ctor @_QMacc_declare_testEdata1_acc_ctor {
! CHECK:         %[[GLOBAL_ADDR:.*]] = fir.address_of(@_QMacc_declare_testEdata1) {acc.declare = #acc.declare<dataClause = acc_create>} : !fir.ref<!fir.array<100000xf32>>
! CHECK:         %[[CREATE:.*]] = acc.create varPtr(%[[GLOBAL_ADDR]] : !fir.ref<!fir.array<100000xf32>>) -> !fir.ref<!fir.array<100000xf32>> {name = "data1"}
! CHECK:         acc.declare_enter dataOperands(%[[CREATE]] : !fir.ref<!fir.array<100000xf32>>)
! CHECK:         acc.terminator
! CHECK:       }

! CHECK-LABEL: fir.global @_QMacc_declare_testEdata2 {acc.declare = #acc.declare<dataClause =  acc_create_zero>} : !fir.array<100000xf32>

! CHECK-LABEL: acc.global_ctor @_QMacc_declare_testEdata2_acc_ctor {
! CHECK:         %[[GLOBAL_ADDR:.*]] = fir.address_of(@_QMacc_declare_testEdata2) {acc.declare = #acc.declare<dataClause =  acc_create_zero>} : !fir.ref<!fir.array<100000xf32>>
! CHECK:         %[[CREATE:.*]] = acc.create varPtr(%[[GLOBAL_ADDR]] : !fir.ref<!fir.array<100000xf32>>) -> !fir.ref<!fir.array<100000xf32>> {dataClause = #acc<data_clause acc_create_zero>, name = "data2"}
! CHECK:         acc.declare_enter dataOperands(%[[CREATE]] : !fir.ref<!fir.array<100000xf32>>)
! CHECK:         acc.terminator
! CHECK:       }
