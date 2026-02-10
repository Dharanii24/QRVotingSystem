const db = require('../config/db');

class Candidate {
  static async create(candidateData) {
    const { candidate_id, name, party, position, bio, photo_path } = candidateData;
    const sql = `INSERT INTO candidates (candidate_id, name, party, position, bio, photo_path) 
                 VALUES (?, ?, ?, ?, ?, ?)`;
    const [result] = await db.query(sql, [candidate_id, name, party, position, bio, photo_path]);
    return result;
  }

  static async findAll() {
    const sql = `SELECT * FROM candidates WHERE is_active = TRUE ORDER BY position, name`;
    const [rows] = await db.query(sql);
    return rows;
  }

  static async findById(candidate_id) {
    const sql = `SELECT * FROM candidates WHERE candidate_id = ?`;
    const [rows] = await db.query(sql, [candidate_id]);
    return rows[0];
  }

  static async update(candidate_id, updateData) {
    const { name, party, position, bio, photo_path, is_active } = updateData;
    const sql = `UPDATE candidates SET 
                 name = ?, party = ?, position = ?, bio = ?, 
                 photo_path = ?, is_active = ? 
                 WHERE candidate_id = ?`;
    const [result] = await db.query(sql, [name, party, position, bio, photo_path, is_active, candidate_id]);
    return result;
  }

  static async delete(candidate_id) {
    const sql = `DELETE FROM candidates WHERE candidate_id = ?`;
    const [result] = await db.query(sql, [candidate_id]);
    return result;
  }

  static async incrementVote(candidate_id) {
    const sql = `UPDATE candidates SET vote_count = vote_count + 1 WHERE candidate_id = ?`;
    const [result] = await db.query(sql, [candidate_id]);
    return result;
  }

  static async getResultsByPosition() {
    const sql = `
      SELECT 
        position,
        candidate_id,
        name,
        party,
        vote_count,
        photo_path,
        RANK() OVER (PARTITION BY position ORDER BY vote_count DESC) as rank
      FROM candidates 
      WHERE is_active = TRUE 
      ORDER BY position, vote_count DESC
    `;
    const [rows] = await db.query(sql);
    return rows;
  }

  static async getTotalVotes() {
    const sql = `SELECT SUM(vote_count) as total_votes FROM candidates`;
    const [rows] = await db.query(sql);
    return rows[0];
  }
}

module.exports = Candidate;