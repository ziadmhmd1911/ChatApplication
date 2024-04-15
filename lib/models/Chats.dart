
class Chats {
  
  List<String> participants;
  List<String> IDs;
  String lastMessage;
  DateTime lastMessageTime;

  Chats({required this.participants, required this.lastMessage, required this.lastMessageTime, required this.IDs});
}