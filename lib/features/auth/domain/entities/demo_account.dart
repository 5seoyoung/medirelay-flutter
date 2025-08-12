/// 데모 계정 엔티티
/// 로그인 페이지와 위젯에서 공통으로 사용
class DemoAccount {
  const DemoAccount({
    required this.employeeId,
    required this.password,
    required this.name,
    required this.department,
    required this.position,
  });

  final String employeeId;
  final String password;
  final String name;
  final String department;
  final String position;

  factory DemoAccount.empty() => const DemoAccount(
    employeeId: '',
    password: '',
    name: '',
    department: '',
    position: '',
  );
}