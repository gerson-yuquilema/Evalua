//import { cn } from "@/lib/utils"

const cn = (...classes: Array<string | false | null | undefined>) =>
  classes.filter(Boolean).join(" ")"

function Skeleton({
  className,
  ...props
}: React.HTMLAttributes<HTMLDivElement>) {
  return (
    <div
      className={cn("animate-pulse rounded-md bg-muted", className)}
      {...props}
    />
  )
}

export { Skeleton }
