"use client"

import { motion } from "framer-motion"
import { useEffect, useState } from "react"

interface AnimatedParticle {
  id: number
  width: number
  height: number
  initialX: number
  initialY: number
  background: string
  duration: number
  delay: number
}

export function ClientOnlyAnimatedBackground() {
  const [particles, setParticles] = useState<AnimatedParticle[]>([])
  const [mounted, setMounted] = useState(false)

  useEffect(() => {
    setMounted(true)
    
    // Generate particles only on client side
    const generatedParticles: AnimatedParticle[] = []
    for (let i = 0; i < 30; i++) {
      generatedParticles.push({
        id: i,
        width: Math.random() * 4 + 1,
        height: Math.random() * 4 + 1,
        initialX: Math.random() * (typeof window !== "undefined" ? window.innerWidth : 1200),
        initialY: Math.random() * (typeof window !== "undefined" ? window.innerHeight : 800),
        background: `linear-gradient(45deg, hsl(${200 + Math.random() * 60}, 70%, 60%), hsl(${260 + Math.random() * 60}, 70%, 60%))`,
        duration: 4 + Math.random() * 3,
        delay: Math.random() * 2,
      })
    }
    setParticles(generatedParticles)
  }, [])

  // Don't render anything on the server
  if (!mounted) {
    return <div className="absolute inset-0 overflow-hidden pointer-events-none" />
  }

  return (
    <div className="absolute inset-0 overflow-hidden pointer-events-none">
      {particles.map((particle) => (
        <motion.div
          key={particle.id}
          className="absolute rounded-full"
          style={{
            width: particle.width,
            height: particle.height,
            background: particle.background,
          }}
          initial={{
            x: particle.initialX,
            y: particle.initialY,
          }}
          animate={{
            y: [null, -30, 30],
            x: [null, -15, 15],
            opacity: [0.2, 0.8, 0.2],
            scale: [1, 1.2, 1],
          }}
          transition={{
            duration: particle.duration,
            repeat: Number.POSITIVE_INFINITY,
            ease: "easeInOut",
            delay: particle.delay,
          }}
        />
      ))}
    </div>
  )
}