package user;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import bbs.Bbs;

public class UserDAO {
	private Connection conn;
	private PreparedStatement pstmt;
	private ResultSet rs;
	
	public UserDAO() {
		try {
			String dbUrl = "jdbc:mariadb://localhost:3306/bbs";
            String dbId = "root";
            String dbPassword = "yu828282";
            Class.forName("org.mariadb.jdbc.Driver");
            conn = DriverManager.getConnection(dbUrl, dbId, dbPassword);
		}catch(Exception e) {
			e.printStackTrace();
		}
	}
	
	public int login(String userId, String userPassword) {
		String SQL = "SELECT userPassword FROM user WHERE userId = ?";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userId);
			rs = pstmt.executeQuery();
			if(rs.next()) {
				if(rs.getString(1).equals(userPassword)) { //첫번째 열의 데이터를 비교해서 서로 일치한다면..
					return 1; //로그인 성공
				}
				else 
					return 0; //일치하지 않는 경우(비밀번호 불일치)
			}
			return -1; //아이디 없을 때
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -2; //db 오류
	}
	
	public int getNext() { // 다음 번호 반환
		String SQL = "SELECT userNo FROM user ORDER BY userNo DESC";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				return rs.getInt(1) + 1; //결과가 있으면 그 다음 값을 반환
			}
			return 1; //첫번째 게시글이면 1 반환
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1; //db 오류
	}	
	
	public int join(User user, String userAddress) {
		String SQL = "INSERT INTO user VALUES (?,?,?,?,?,?,?,?,?,?)";
		try {
			pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, null);
			pstmt.setString(2, user.getUserId());
			pstmt.setString(3, user.getUserPassword());
			pstmt.setString(4, user.getUserName());
			pstmt.setString(5, user.getUserPhone());
			pstmt.setString(6, user.getUserEmail());
			pstmt.setString(7, userAddress);
			pstmt.setString(8, user.getUserTitle());
			pstmt.setString(9, user.getUserTeam());
			pstmt.setInt(10, 1);
			return pstmt.executeUpdate(); //반드시 0 이상의 숫자가 반환된다
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1; // db오류
	}
	
	public User getUser(String userID) { // 유저 정보 가져오기
		String SQL = "SELECT * FROM user WHERE userId = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userID);
			rs = pstmt.executeQuery();
			if(rs.next()) { //실행이 된다면 정보 return
				User user = new User();
				user.setUserNo(rs.getInt(1));
				user.setUserId(rs.getString(2));
				user.setUserPassword(rs.getString(3));
				user.setUserName(rs.getString(4));
				user.setUserPhone(rs.getString(5));
				user.setUserEmail(rs.getString(6));
				user.setUserAddress(rs.getString(7));
				user.setUserTitle(rs.getString(8));
				user.setUserTeam(rs.getString(9));
				user.setUserAccept(rs.getInt(10));		
				return user;
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		return null; //존재하지 않으면 null 반환		
		
	}
	
	public User getUserFromName(String userName) { // 유저 정보 가져오기
		String SQL = "SELECT * FROM user WHERE userName LIKE ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, "%"+ userName.trim() +"%");
			rs = pstmt.executeQuery();
			if(rs.next()) { //실행이 된다면 정보 return
				User user = new User();
				user.setUserNo(rs.getInt(1));
				user.setUserId(rs.getString(2));
				user.setUserPassword(rs.getString(3));
				user.setUserName(rs.getString(4));
				user.setUserPhone(rs.getString(5));
				user.setUserEmail(rs.getString(6));
				user.setUserAddress(rs.getString(7));
				user.setUserTitle(rs.getString(8));
				user.setUserTeam(rs.getString(9));
				user.setUserAccept(rs.getInt(10));		
				return user;
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		return null; //존재하지 않으면 null 반환		
		
	}
	
	public User getUserFromNo(int userNo) { // 유저 정보 가져오기
		String SQL = "SELECT * FROM user WHERE userNo LIKE ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, userNo);
			rs = pstmt.executeQuery();
			if(rs.next()) { //실행이 된다면 정보 return
				User user = new User();
				user.setUserNo(rs.getInt(1));
				user.setUserId(rs.getString(2));
				user.setUserPassword(rs.getString(3));
				user.setUserName(rs.getString(4));
				user.setUserPhone(rs.getString(5));
				user.setUserEmail(rs.getString(6));
				user.setUserAddress(rs.getString(7));
				user.setUserTitle(rs.getString(8));
				user.setUserTeam(rs.getString(9));
				user.setUserAccept(rs.getInt(10));		
				return user;
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		return null; //존재하지 않으면 null 반환		
		
	}
	
	public int delete(int userNo) {
		String SQL = "UPDATE user SET userAccept = 0 WHERE userNo = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, userNo);
			return pstmt.executeUpdate(); 
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1; //db 오류		
	}
	
	public int update(String userPassword, String userName, String userPhone, String userEmail, String userAddress, String userTitle, String userTeam, int userNo){
		String SQL = "UPDATE user SET userPassword = ?, userName = ?, userPhone =?, userEmail = ?, userAddress = ?, userTitle = ?, userTeam = ? WHERE userNo = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userPassword);
			pstmt.setString(2, userName);
			pstmt.setString(3, userPhone);
			pstmt.setString(4, userEmail);
			pstmt.setString(5, userAddress);
			pstmt.setString(6, userTitle);
			pstmt.setString(7, userTeam);
			pstmt.setInt(8, userNo);
			return pstmt.executeUpdate(); 
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1; //db 오류
	}

	public ArrayList<User> getList(int pageNumber) {
		String SQL = "SELECT * FROM user WHERE userAccept = 1 ORDER BY userNo DESC LIMIT ?, 10";
		ArrayList<User> users = new ArrayList<User>();
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL); //다른 함수와 겹칠수 있어 함수 내부로...
			pstmt.setInt(1, (pageNumber-1) * 10);  //14개 게시글이 있다면 15-(2-1)*10 =5, 2page엔 1, 2, 3, 4 총 4개의 글이 나타남
			rs = pstmt.executeQuery(); // sql문 실행
			while (rs.next()) { // 한바퀴 회전당 VO를 하나씩 생성
				User user = new User();
				user.setUserNo(rs.getInt(1));
				user.setUserId(rs.getString(2));
				user.setUserPassword(rs.getString(3));
				user.setUserName(rs.getString(4));
				user.setUserPhone(rs.getString(5));
				user.setUserEmail(rs.getString(6));
				user.setUserAddress(rs.getString(7));
				user.setUserTitle(rs.getString(8));
				user.setUserTeam(rs.getString(9));
				user.setUserAccept(rs.getInt(10));		
				users.add(user);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		return users;
	}	
	
	public ArrayList<User> getUserSearch(String searchWord, int pageNumber){
		ArrayList<User> users = new ArrayList<User>();
		String SQL = "SELECT * FROM user WHERE userId LIKE ? OR userName LIKE ? OR userPhone LIKE ? OR userEmail LIKE ? OR userTitle LIKE ? OR userTeam LIKE ? AND userAccept = 1 ORDER BY userNo DESC LIMIT ?, 10";
//		if(searchPart.trim().equals("userId")) {
//		SQL = "SELECT * FROM user WHERE userId LIKE ? AND userAccept = 1 ORDER BY userNo DESC LIMIT ?, 10";
//		}
//		if(searchPart.trim().equals("userName")) {
//			SQL = "SELECT * FROM user WHERE userName LIKE ? AND userAccept = 1 ORDER BY userNo DESC LIMIT ?, 10";
//		}
//		if(searchPart.trim().equals("userPhone")) {
//			SQL = "SELECT * FROM user WHERE userPhone LIKE ? AND userAccept = 1 ORDER BY userNo DESC LIMIT ?, 10";
//		}
//		if(searchPart.trim().equals("userEmail")) {
//			SQL = "SELECT * FROM user WHERE userEmail LIKE ? AND userAccept = 1 ORDER BY userNo DESC LIMIT ?, 10";
//		}
//		if(searchPart.trim().equals("userTitle")) {
//			SQL = "SELECT * FROM user WHERE userTitle LIKE ? AND userAccept = 1 ORDER BY userNo DESC LIMIT ?, 10";
//		}
//		if(searchPart.trim().equals("userTeam")) {
//			SQL = "SELECT * FROM user WHERE userTeam LIKE ? AND userAccept = 1 ORDER BY userNo DESC LIMIT ?, 10";
//		}
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL); // sql준비
			pstmt.setString(1, "%"+searchWord.trim()+"%");
			pstmt.setString(2, "%"+searchWord.trim()+"%");
			pstmt.setString(3, "%"+searchWord.trim()+"%");
			pstmt.setString(4, "%"+searchWord.trim()+"%");
			pstmt.setString(5, "%"+searchWord.trim()+"%");
			pstmt.setString(6, "%"+searchWord.trim()+"%");
			pstmt.setInt(7, (pageNumber-1) * 10); //14개 게시글이 있다면 15-(2-1)*10 =5, 2page엔 1, 2, 3, 4 총 4개의 글이 나타남
			rs = pstmt.executeQuery(); // sql문 실행
			while (rs.next()) { // 한바퀴 회전당 VO를 하나씩 생성
				User user = new User();
				user.setUserNo(rs.getInt(1));
				user.setUserId(rs.getString(2));
				user.setUserPassword(rs.getString(3));
				user.setUserName(rs.getString(4));
				user.setUserPhone(rs.getString(5));
				user.setUserEmail(rs.getString(6));
				user.setUserAddress(rs.getString(7));
				user.setUserTitle(rs.getString(8));
				user.setUserTeam(rs.getString(9));
				user.setUserAccept(rs.getInt(10));		
				users.add(user);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		return users;
	}
	
	public int getTotal() {	// 전체 유저 수
		String SQL = "SELECT COUNT (*) AS total FROM user WHERE userAccept = 1";				
		try {				
			PreparedStatement pstmt = conn.prepareStatement(SQL);				
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				return rs.getInt("total");
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}			
		return 0;//db 오류
	}
	
	public int getSearchTotal(String searchWord) {	// 검색 된 수의 전체 게시글 수
		String SQL = "SELECT COUNT (*) AS total FROM user WHERE userId LIKE ? OR userName LIKE ? OR userPhone LIKE ? OR userEmail LIKE ? OR userTitle LIKE ? OR userTeam LIKE ? AND userAccept = 1;";
//		if(searchPart.trim().equals("userId")) {
//			SQL = "SELECT COUNT (*) AS total FROM user WHERE userId LIKE ? AND userAccept = 1;";
//			}
//		if(searchPart.trim().equals("userName")) {
//			SQL = "SELECT COUNT (*) AS total FROM user WHERE userName LIKE ? AND userAccept = 1;";
//			}
//		if(searchPart.trim().equals("userPhone")) {
//			SQL = "SELECT COUNT (*) AS total FROM user WHERE userPhone LIKE ? AND userAccept = 1;";
//			}		
//		if(searchPart.trim().equals("userEmail")) {
//			SQL = "SELECT COUNT (*) AS total FROM user WHERE userEmail LIKE ? AND userAccept = 1;";
//			}		
//		if(searchPart.trim().equals("userTitle")) {
//			SQL = "SELECT COUNT (*) AS total FROM user WHERE userTitle LIKE ? AND userAccept = 1;";
//			}		
//		if(searchPart.trim().equals("userTeam")) {
//			SQL = "SELECT COUNT (*) AS total FROM user WHERE userTeam LIKE ? AND userAccept = 1;";
//			}		
		try {				
			PreparedStatement pstmt = conn.prepareStatement(SQL);	
			pstmt.setString(1, "%"+searchWord.trim()+"%");  //bbsTitle? bbsContent?	 
			pstmt.setString(2, "%"+searchWord.trim()+"%");
			pstmt.setString(3, "%"+searchWord.trim()+"%");
			pstmt.setString(4, "%"+searchWord.trim()+"%");
			pstmt.setString(5, "%"+searchWord.trim()+"%");
			pstmt.setString(6, "%"+searchWord.trim()+"%");
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				return rs.getInt("total");
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}			
		return 0;//db 오류
	}
	
	public String findUserId(String userName, String userPhone) { // 유저 정보 가져오기
		String SQL = "SELECT userId FROM user WHERE userName LIKE ? AND userPhone LIKE ? AND userAccept LIKE 1";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userName.trim());
			pstmt.setString(2, userPhone.trim());
			rs = pstmt.executeQuery();
			if(rs.next()) { //실행이 된다면 정보 return
				return rs.getString("userId");
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		return null; //존재하지 않으면 null 반환		
		
	}
	
	public String findUserPw(String userName, String userPhone, String userEmail) { // 유저 정보 가져오기
		String SQL = "SELECT userPassword FROM user WHERE userName LIKE ? AND userPhone LIKE ? AND userEmail LIKE ? AND userAccept LIKE 1";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, userName.trim());
			pstmt.setString(2, userPhone.trim());
			pstmt.setString(3, userEmail.trim());
			rs = pstmt.executeQuery();
			if(rs.next()) { //실행이 된다면 정보 return
				return rs.getString("userPassword");
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		return null; //존재하지 않으면 null 반환		
		
	}

}
