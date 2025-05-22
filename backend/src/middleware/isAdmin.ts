import { Request, Response, NextFunction } from 'express';
import { verifyAccessToken } from '../auth/jwt';
import prisma from '../dbClient';

interface JwtPayload {
    userId: string;
    email: string;
    iat?: number;
    exp?: number;
}

export const isAdmin = async (req: Request, res: Response, next: NextFunction) => {
    try {
        // Get the token from the Authorization header
        const authHeader = req.headers.authorization;
        if (!authHeader?.startsWith('Bearer ')) {
            return res.status(401).json({ message: 'No token provided' });
        }

        const token = authHeader.split(' ')[1];
        const decoded = verifyAccessToken(token) as JwtPayload;

        if (!decoded) {
            return res.status(401).json({ message: 'Invalid token' });
        }

        // Get user from database to check role
        const user = await prisma.user.findUnique({
            where: { id: decoded.userId },
            select: { role: true }
        });

        if (!user || user.role !== 'admin') {
            return res.status(403).json({ message: 'Access denied. Admin privileges required.' });
        }

        // Add user info to request for use in route handlers
        req.user = { id: decoded.userId, role: user.role };
        next();
    } catch (error) {
        console.error('Admin middleware error:', error);
        res.status(500).json({ message: 'Internal server error' });
    }
}; 