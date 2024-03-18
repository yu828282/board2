package bbs;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class BbsDAO {
	private Connection conn;
	private ResultSet rs;

	public BbsDAO() {
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
	
	public String getDate() {
		String SQL = "SELECT NOW()";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL); //다른 함수와 충돌나지 않게 함수 내부로...
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getString(1); //결과가 있다면 현재 날짜 그대로 반환
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		return ""; //데이터베이스 오류가 나는 경우 빈 값을 반환
	}
	
	public int getNext() {
		String SQL = "SELECT bbsNo FROM bbs ORDER BY bbsNo DESC";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL); //다른 함수와 겹칠수 있어 함수 내부로...
			rs = pstmt.executeQuery();
			if(rs.next()) {
				return rs.getInt(1) + 1; //결과가 있다면? 검색된 것 다음을 반환
			}
			return 1; //첫번째 게시물은 1 반환
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1; //오류
	}
	public int write(String bbsTitle, String userId, String bbsContent) {
		String SQL = "INSERT INTO bbs VALUES (?, ?, ?, ?, ?, ?)";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL); //다른 함수와 겹칠수 있어 함수 내부로...
			pstmt.setInt(1, getNext());
			pstmt.setString(2, bbsTitle);
			pstmt.setString(3, bbsContent);
			pstmt.setString(4, userId);
			pstmt.setString(5, getDate());
			pstmt.setInt(6, 1);
			return pstmt.executeUpdate(); // 1 이상의 값을 반환
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1; //데이터베이스 오류가 나는 경우 -1을 반환
	}
	public ArrayList<Bbs> getList(int pageNumber) {
		String SQL = "SELECT * FROM bbs WHERE bbsAvailable = 1 ORDER BY bbsNo DESC LIMIT ?, 10";
		ArrayList<Bbs> list = new ArrayList<Bbs>();
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL); //다른 함수와 겹칠수 있어 함수 내부로...
			pstmt.setInt(1, (pageNumber-1) * 10);  //14개 게시글이 있다면 15-(2-1)*10 =5, 2page엔 1, 2, 3, 4 총 4개의 글이 나타남
			rs = pstmt.executeQuery(); // sql문 실행
			while (rs.next()) { // 한바퀴 회전당 VO를 하나씩 생성
				Bbs bbs = new Bbs();
				bbs.setBbsNo(rs.getInt(1));
				bbs.setBbsTitle(rs.getString(2));
				bbs.setBbsContent(rs.getString(3));
				bbs.setUserId(rs.getString(4));
				bbs.setBbsDate(rs.getString(5));
				bbs.setBbsAvailable(rs.getInt(6));
				list.add(bbs);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		return list;
	}	
	public boolean nextPage(int pageNumber) {
		String SQL = "SELECT * FROM bbs WHERE bbsAvailable = 1 ORDER BY bbbbsNo DESC LIMIT ?, 10";  // ?+1-10 행 부터 10개 출력
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, (pageNumber-1) * 10); 
			rs = pstmt.executeQuery();
			if(rs.next()) { //게시글이 0이나 10의 배수라면 bbsID < 1이 되어 반환값이 없기 때문에 false처리
				return true;
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		return false;
	}
	
	public int getTotal() {	// 전체 게시글 수
		String SQL = "SELECT COUNT (*) AS total FROM bbs WHERE bbsAvailable = 1";				
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
	
	public Bbs getBbs(int bbsID) { // 글 읽기
		String SQL = "SELECT * FROM bbs WHERE bbsNo = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, bbsID);
			rs = pstmt.executeQuery();
			if(rs.next()) { //실행이 된다면 정보 return
				Bbs bbs = new Bbs();
                bbs.setBbsNo(rs.getInt(1));
                bbs.setBbsTitle(rs.getString(2));
                bbs.setBbsContent(rs.getString(3));
                bbs.setUserId(rs.getString(4));
                bbs.setBbsDate(rs.getString(5));
                bbs.setBbsAvailable(rs.getInt(6));
				return bbs;
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		return null; //글이 존재하지 않으면 null 반환		
		
	}
	
	public int update(int bbsID, String bbsTitle, String bbsContent){
		String SQL = "UPDATE bbs SET bbsTitle = ?, bbsContent = ? WHERE bbsNo = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setString(1, bbsTitle);
			pstmt.setString(2, bbsContent);
			pstmt.setInt(3, bbsID);
			return pstmt.executeUpdate(); 
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1; //db 오류
	}
	
	public int delete(int bbsID) {
		String SQL = "UPDATE bbs SET bbsAvailable = 0 WHERE bbsNo = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, bbsID);
			return pstmt.executeUpdate(); 
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1; //db 오류		
	}
	
	public ArrayList<Bbs> getBbsSearch(String searchPart, String searchWord, int pageNumber){
		ArrayList<Bbs> boards = new ArrayList<Bbs>();
		String SQL = null;
		if(searchPart.trim().equals("bbsTitle")) {
		SQL = "SELECT * FROM bbs WHERE bbsTitle LIKE ? AND bbsAvailable = 1 ORDER BY bbsNo DESC LIMIT ?, 10";
		}
		if(searchPart.trim().equals("bbsContent")) {
		SQL = "SELECT * FROM bbs WHERE bbsContent LIKE ? AND bbsAvailable = 1 ORDER BY bbsNo DESC LIMIT ?, 10";
		}
		if(searchPart.trim().equals("userId")) {
		SQL = "SELECT * FROM bbs WHERE userId LIKE ? AND bbsAvailable = 1 ORDER BY bbsNo DESC LIMIT ?, 10";
		}
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL); // sql준비
			pstmt.setString(1, "%"+searchWord.trim()+"%");  //bbsTitle? bbsContent?	 
			pstmt.setInt(2, (pageNumber-1) * 10); //14개 게시글이 있다면 15-(2-1)*10 =5, 2page엔 1, 2, 3, 4 총 4개의 글이 나타남
			rs = pstmt.executeQuery(); // sql문 실행
			while (rs.next()) { // 한바퀴 회전당 VO를 하나씩 생성
				Bbs bbs = new Bbs();
				bbs.setBbsNo(rs.getInt(1));
				bbs.setBbsTitle(rs.getString(2));
				bbs.setBbsContent(rs.getString(3));
				bbs.setUserId(rs.getString(4));
				bbs.setBbsDate(rs.getString(5));
				bbs.setBbsAvailable(rs.getInt(6));
				boards.add(bbs);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		return boards;
	}
	
	public int getSearchTotal(String searchPart, String searchWord) {	// 검색 된 수의 전체 게시글 수
		String SQL = null;
		if(searchPart.trim().equals("bbsTitle")) {
			SQL = "SELECT COUNT (*) AS total FROM bbs WHERE bbsTitle LIKE ? AND bbsAvailable = 1;";
			}
			if(searchPart.trim().equals("bbsContent")) {
			SQL = "SELECT COUNT (*) AS total FROM bbs WHERE bbsContent LIKE ? AND bbsAvailable = 1;";
			}
			if(searchPart.trim().equals("userId")) {
				SQL = "SELECT COUNT (*) AS total FROM bbs WHERE userId LIKE ? AND bbsAvailable = 1;";
				}		
		try {				
			PreparedStatement pstmt = conn.prepareStatement(SQL);	
			pstmt.setString(1, "%"+searchWord.trim()+"%");  //bbsTitle? bbsContent?	 
			rs = pstmt.executeQuery();
			
			if(rs.next()) {
				return rs.getInt("total");
			}
			
		} catch (Exception e) {
			e.printStackTrace();
		}			
		return 0;//db 오류
	}
}
