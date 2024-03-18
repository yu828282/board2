package comment;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;

public class CommentDAO {
	
	private Connection conn;//데이터베이스에 접근하게 해주는 하나의 객체
	private ResultSet rs;//정보를 담을 수 있는 객체
	
	public CommentDAO() {
		try {//예외처리
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
		return ""; //db 오류
	}
	
	public int getNext() {
		String SQL="SELECT commentId from comment order by commentId DESC";//마지막 게시물 반환
		try {
			PreparedStatement pstmt=conn.prepareStatement(SQL);
			rs=pstmt.executeQuery();
			if(rs.next()) {
				return rs.getInt(1) + 1;
			}
			return 1; // 첫 번째 게시물인 경우
			
		} catch(Exception e) {
			e.printStackTrace();
		}
		return -1;//데이터베이스 오류
	}
	
	public int write(String commentContent, String userID, int bbsID) {
		String SQL="INSERT INTO comment VALUES (?, ?, ?, ?, ?, ?)";
		try {
			PreparedStatement pstmt=conn.prepareStatement(SQL);
			pstmt.setInt(1, getNext());
			pstmt.setString(2, commentContent);
			pstmt.setString(3, userID);
			pstmt.setInt(4, 1);  //0 :삭제 1 : 보여주기
			pstmt.setInt(5, bbsID);
			pstmt.setString(6, getDate());
			return pstmt.executeUpdate();
			
		} catch(Exception e) {
			e.printStackTrace();
		}
		return -1;//데이터베이스 오류
	}
	
	public int getTotal(int bbsID) {	// 전체 게시글 수
		String SQL = "SELECT COUNT (*) AS total FROM comment WHERE commentAvailable = 1 AND bbsNo = ?";				
		try {				
			PreparedStatement pstmt = conn.prepareStatement(SQL);	
			pstmt.setInt(1, bbsID);
			rs=pstmt.executeQuery();			
			if(rs.next()) {
				return rs.getInt("total");
			}			
		} catch (Exception e) {
			e.printStackTrace();
		}			
		return -1;//db 오류
	}
	
	public int update(String commentContent, int commentID) {
		String SQL="UPDATE comment SET commentContent = ? where commentId = ?";//특정한 아이디에 해당하는 제목과 내용을 바꿔준다. 
		try {
			PreparedStatement pstmt=conn.prepareStatement(SQL);
			pstmt.setString(1, commentContent);//물음표의 순서
			pstmt.setInt(2, commentID);
			return pstmt.executeUpdate();//insert,delete,update			
		} catch(Exception e) {
			e.printStackTrace();
		}
		return -1;//데이터베이스 오류
	}
	
	public int delete(int commentID) {
		String SQL = "UPDATE comment SET commentAvailable = 0 WHERE commentId = ?";
		try {
			PreparedStatement pstmt=conn.prepareStatement(SQL);
			pstmt.setInt(1, commentID);
			return pstmt.executeUpdate();			
		} catch(Exception e) {
			e.printStackTrace();
		}
		return -1;//데이터베이스 오류
	}

	public ArrayList<Comment> getList(int bbsID){ 
		String SQL = "SELECT * FROM comment WHERE commentAvailable = 1 AND bbsNo = ? ORDER BY commentId ASC";
		ArrayList<Comment> list = new ArrayList<Comment>();
		try {
			PreparedStatement pstmt = conn.prepareStatement(SQL); // sql준비
			pstmt.setInt(1, bbsID); 
			rs = pstmt.executeQuery(); // sql문 실행
			while (rs.next()) { // 한바퀴 회전당 VO를 하나씩 생성 (순서 틀리면 안됨!!!!)
				Comment comment = new Comment();
				comment.setCommentId(rs.getInt(1));
				comment.setCommentContent(rs.getString(2));
				comment.setUserId(rs.getString(3));
				comment.setCommentAvailable(rs.getInt(4));
				comment.setBbsNo(rs.getInt(5));
				comment.setCommentDate(rs.getString(6));
				list.add(comment);
			}
		}catch(Exception e) {
			e.printStackTrace();
		}
		return list;
	}
	
	public Comment getComment(int commentID) {//하나의 댓글 내용을 불러오는 함수
		String SQL="SELECT * FROM comment WHERE commentId = ?";
		try {
			PreparedStatement pstmt=conn.prepareStatement(SQL);
			pstmt.setInt(1, commentID);
			rs=pstmt.executeQuery();//select
			if(rs.next()) {//결과가 있다면
				Comment comment = new Comment();
				comment.setCommentId(rs.getInt(1));
				comment.setCommentContent(rs.getString(2));
				comment.setUserId(rs.getString(3));
				comment.setCommentAvailable(rs.getInt(4));
				comment.setBbsNo(rs.getInt(5));
				comment.setCommentDate(rs.getString(6));
				return comment;
			}			
		} catch(Exception e) {
			e.printStackTrace();
		}
		return null;
	}
	
	
}