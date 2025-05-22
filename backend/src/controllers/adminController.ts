import { Request, Response } from 'express';
import prisma from '../dbClient';

export const promoteToAdmin = async (req: Request, res: Response) => {
    try {
        const { userId } = req.body;

        if (!userId) {
            return res.status(400).json({ message: 'User ID is required' });
        }

        // Check if user exists
        const user = await prisma.user.findUnique({
            where: { id: userId }
        });

        if (!user) {
            return res.status(404).json({ message: 'User not found' });
        }

        // Update user role to admin
        const updatedUser = await prisma.user.update({
            where: { id: userId },
            data: { role: 'admin' },
            select: {
                id: true,
                username: true,
                email: true,
                role: true,
                createdAt: true,
                updatedAt: true,
                avatarUrl: true
            }
        });

        res.json({ user: updatedUser });
    } catch (error) {
        console.error('Error promoting user to admin:', error);
        res.status(500).json({ message: 'Internal server error' });
    }
}; 