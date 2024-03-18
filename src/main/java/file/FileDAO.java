package file;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

import comment.Comment;

public class FileDAO {

	private Connection conn; 
	private ResultSet rs;
	
	public FileDAO() {
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
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			rs = pstmt.executeQuery();
			if (rs.next()) {
				return rs.getString(1); //결과가 있으면 현재 날짜를 그대로 반환
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		return ""; 
	}

	
	public int getNext() { // 다음에 작성될 글의 번호 반환
		String SQL = "SELECT fileNo FROM file ORDER BY fileNO DESC";
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
		return -1; 
	}
	

	public int write(int bbsID, String fileName, String fileRealName, long fileSize) {
		String fileExt = fileName.substring(fileName.lastIndexOf(".") + 1);
		String SQL = "INSERT INTO file VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, getNext());
			pstmt.setInt(2, bbsID);
			pstmt.setString(3, fileName);
			pstmt.setString(4, fileRealName);
			pstmt.setLong(5, fileSize);
			pstmt.setString(6, fileExt); 
			pstmt.setString(7, getDate());
			pstmt.setInt(8, 1); //삭제여부 (1 = 삭제 안함)
			return pstmt.executeUpdate(); 
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1; //db 오류
	}

	public ArrayList<Files> getList(int bbsID){ 
		String SQL = "SELECT * FROM file WHERE fileDelete = 1 AND bbsNo = ? ORDER BY fileNo ASC";
		ArrayList<Files> list = new ArrayList<Files>();
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL); // sql준비
			pstmt.setInt(1, bbsID); 
			rs = pstmt.executeQuery(); // sql문 실행
			while (rs.next()) { // 한바퀴 회전당 VO를 하나씩 생성 (순서 틀리면 안됨!!!!)
				Files file = new Files();
				file.setFileNo(rs.getInt(1));
				file.setBbsNo(rs.getInt(2));
				file.setFileName(rs.getString(3));
				file.setFileRealName(rs.getString(4));
				file.setFileSize(rs.getInt(5));
				file.setFileExt(rs.getString(6));
				file.setFileDate(rs.getString(7));
				file.setFileDelete(rs.getInt(8));
				list.add(file);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		return list;
	}
	
	public int delete(int fileNo) {
		String SQL = "UPDATE file SET fileDelete = 0 WHERE fileNo = ?";
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL);
			pstmt.setInt(1, fileNo);
			return pstmt.executeUpdate(); 
		}catch(Exception e) {
			e.printStackTrace();
		}
		return -1; //db 오류		
	}
}
