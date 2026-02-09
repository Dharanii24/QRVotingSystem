// const db = require("../config/db");

// // Save vote
// exports.addVote = (userId, candidateId) => {
//     return new Promise((resolve, reject) => {
//         const sql = "INSERT INTO Votes (user_id, candidate_id) VALUES (?, ?)";
//         db.query(sql, [userId, candidateId], (err, result) => {
//             if (err) reject(err);
//             else resolve(result);
//         });
//     });
// };

const db = require('../config/db');
const crypto = require('crypto');

class Vote {
  static async create(voteData) {
    const { voter_id, candidate_id, qr_verified, ip_address, user_agent } = voteData;
    const vote_id = crypto.randomBytes(16).toString('hex');
    
    const sql = `INSERT INTO votes (vote_id, voter_id, candidate_id, qr_verified, ip_address, user_agent) 
                 VALUES (?, ?, ?, ?, ?, ?)`;
    const [result] = await db.query(sql, [vote_id, voter_id, candidate_id, qr_verified, ip_address, user_agent]);
    return { ...result, vote_id };
  }

  static async hasVoted(voter_id) {
    const sql = `SELECT * FROM votes WHERE voter_id = ?`;
    const [rows] = await db.query(sql, [voter_id]);
    return rows.length > 0;
  }

  static async getVoteByVoter(voter_id) {
    const sql = `SELECT v.*, c.full_name as candidate_name, c.position 
                 FROM votes v 
                 JOIN candidates c ON v.candidate_id = c.candidate_id 
                 WHERE v.voter_id = ?`;
    const [rows] = await db.query(sql, [voter_id]);
    return rows[0];
  }

  static async getAllVotes() {
    const sql = `
      SELECT 
        v.vote_id,
        v.voter_id,
        u.full_name as voter_name,
        v.candidate_id,
        c.full_name as candidate_name,
        c.position,
        v.qr_verified,
        v.voted_at,
        v.ip_address
      FROM votes v
      JOIN users u ON v.voter_id = u.voter_id
      JOIN candidates c ON v.candidate_id = c.candidate_id
      ORDER BY v.voted_at DESC
    `;
    const [rows] = await db.query(sql);
    return rows;
  }

  static async getVotingTimeline() {
    const sql = `
      SELECT 
        DATE(voted_at) as date,
        HOUR(voted_at) as hour,
        COUNT(*) as vote_count
      FROM votes
      GROUP BY DATE(voted_at), HOUR(voted_at)
      ORDER BY date DESC, hour DESC
      LIMIT 24
    `;
    const [rows] = await db.query(sql);
    return rows;
  }
}

module.exports = Vote;