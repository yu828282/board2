package comment;

public class Comment {
	private int commentId;
	private String commentContent;
	private String userId;
	private int commentAvailable;
	private int bbsNo;
	private String commentDate;
	
	public int getCommentId() {
		return commentId;
	}
	public void setCommentId(int commentId) {
		this.commentId = commentId;
	}
	public String getCommentContent() {
		return commentContent;
	}
	public void setCommentContent(String commentContent) {
		this.commentContent = commentContent;
	}
	public String getUserId() {
		return userId;
	}
	public void setUserId(String userId) {
		this.userId = userId;
	}
	public int getCommentAvailable() {
		return commentAvailable;
	}
	public void setCommentAvailable(int commentAvailable) {
		this.commentAvailable = commentAvailable;
	}
	public int getBbsNo() {
		return bbsNo;
	}
	public void setBbsNo(int bbsNo) {
		this.bbsNo = bbsNo;
	}
	public String getCommentDate() {
		return commentDate;
	}
	public void setCommentDate(String commentDate) {
		this.commentDate = commentDate;
	}

}
