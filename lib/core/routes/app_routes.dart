import 'package:get/get.dart';

import '../../features/auth/screens/splash_screen.dart';
import '../../features/auth/screens/login_screen.dart';
import '../../features/auth/screens/register_screen.dart';
import '../../features/auth/screens/onboarding_screen.dart';

import '../../features/client/screens/client_home_screen.dart';
import '../../features/client/screens/appointments/appointment_list_screen.dart';
import '../../features/client/screens/appointments/appointment_create_screen.dart';
import '../../features/client/screens/repairs/repair_list_screen.dart';
import '../../features/client/screens/repairs/repair_detail_screen.dart';
import '../../features/client/screens/chat/chatbot_screen.dart';
import '../../features/client/screens/chat/technician_chat_screen.dart';
import '../../features/client/screens/offers/offers_screen.dart';
import '../../features/client/screens/profile/profile_screen.dart';

import '../../features/technician/screens/technician_home_screen.dart';
import '../../features/technician/screens/schedule/schedule_screen.dart';
import '../../features/technician/screens/repairs/tech_repair_list_screen.dart';
import '../../features/technician/screens/repairs/tech_repair_detail_screen.dart';

import '../../features/admin/screens/admin_home_screen.dart';
import '../../features/admin/screens/dashboard/dashboard_screen.dart';
import '../../features/admin/screens/technicians/technician_management_screen.dart';
import '../../features/admin/screens/statistics/statistics_screen.dart';
import '../../features/admin/screens/offers/offer_management_screen.dart';

class AppRoutes {
  // Auth Routes
  static const String splash = '/splash';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  
  // Client Routes
  static const String clientHome = '/client/home';
  static const String appointmentList = '/client/appointments';
  static const String appointmentCreate = '/client/appointments/create';
  static const String repairList = '/client/repairs';
  static const String repairDetail = '/client/repairs/detail';
  static const String chatbot = '/client/chatbot';
  static const String technicianChat = '/client/chat/technician';
  static const String offers = '/client/offers';
  static const String profile = '/client/profile';
  
  // Technician Routes
  static const String technicianHome = '/technician/home';
  static const String schedule = '/technician/schedule';
  static const String techRepairList = '/technician/repairs';
  static const String techRepairDetail = '/technician/repairs/detail';
  
  // Admin Routes
  static const String adminHome = '/admin/home';
  static const String dashboard = '/admin/dashboard';
  static const String technicianManagement = '/admin/technicians';
  static const String statistics = '/admin/statistics';
  static const String offerManagement = '/admin/offers';
  
  static List<GetPage> routes = [
    // Auth
    GetPage(name: splash, page: () => const SplashScreen()),
    GetPage(name: onboarding, page: () => const OnboardingScreen()),
    GetPage(name: login, page: () => const LoginScreen()),
    GetPage(name: register, page: () => const RegisterScreen()),
    
    // Client
    GetPage(name: clientHome, page: () => const ClientHomeScreen()),
    GetPage(name: appointmentList, page: () => const AppointmentListScreen()),
    GetPage(name: appointmentCreate, page: () => const AppointmentCreateScreen()),
    GetPage(name: repairList, page: () => const RepairListScreen()),
    GetPage(name: repairDetail, page: () => const RepairDetailScreen()),
    GetPage(name: chatbot, page: () => const ChatbotScreen()),
    GetPage(name: technicianChat, page: () => const TechnicianChatScreen()),
    GetPage(name: offers, page: () => const OffersScreen()),
    GetPage(name: profile, page: () => const ProfileScreen()),
    
    // Technician
    GetPage(name: technicianHome, page: () => const TechnicianHomeScreen()),
    GetPage(name: schedule, page: () => const ScheduleScreen()),
    GetPage(name: techRepairList, page: () => const TechRepairListScreen()),
    GetPage(name: techRepairDetail, page: () => const TechRepairDetailScreen()),
    
    // Admin
    GetPage(name: adminHome, page: () => const AdminHomeScreen()),
    GetPage(name: dashboard, page: () => const DashboardScreen()),
    GetPage(name: technicianManagement, page: () => const TechnicianManagementScreen()),
    GetPage(name: statistics, page: () => const StatisticsScreen()),
    GetPage(name: offerManagement, page: () => const OfferManagementScreen()),
  ];
}
